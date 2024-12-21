import UIKit
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 백그라운드 작업 등록
        registerBackgroundTasks()
        
        // 알림 권한 요청
        requestNotificationPermissions()
        
        // Background Fetch 활성화
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
    
    // MARK: - Background Task Registration
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    // MARK: - Handle Background Task
    func handleAppRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("백그라운드 작업이 시간 초과되었습니다.")
        }
        
        // 데이터를 가져오는 실제 작업 수행
        fetchData { success in
            task.setTaskCompleted(success: success)
            if success {
                self.scheduleLocalNotification()
            }
        }
        
        // 다음 작업 예약
        scheduleAppRefresh()
    }
    
    func fetchData(completion: @escaping (Bool) -> Void) {
        print("백그라운드 작업 실행 중...")
        // 네트워크 요청 또는 데이터 업데이트 수행
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            print("데이터 가져오기 완료")
            completion(true) // 작업 성공
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15분 후
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Background Task 요청 실패: \(error)")
        }
    }
    
    // MARK: - Background Fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        fetchData { success in
            if success {
                completionHandler(.newData)
                self.scheduleLocalNotification()
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    // MARK: - Notification Permission Request
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("알림 권한 허용됨")
            } else {
                print("알림 권한 거부됨")
            }
        }
    }
    
    // MARK: - Local Notification
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "백그라운드 작업 완료"
        content.body = "데이터가 업데이트되었습니다."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "backgroundTaskComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("로컬 알림 추가 중 오류 발생: \(error)")
            }
        }
    }
}
