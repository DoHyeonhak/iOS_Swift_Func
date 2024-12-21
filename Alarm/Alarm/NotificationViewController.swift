import UIKit
import UserNotifications

class NotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 알림 권한 요청
        requestNotificationPermission()
        
        // 1년 후 사진 확인 알림 스케줄링
        scheduleNotification()
    }
    
    // 1. 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(String(describing: error))")
            }
        }
    }
    
//    // 2. 알림 스케줄링(1년)
//    func schedulePhotoCheckNotification() {
//        // 알림 내용 설정
//        let content = UNMutableNotificationContent()
//        content.title = "갤러리에서 추억을 확인해보세요!"
//        content.body = "1년 전 오늘의 사진을 확인해보세요."
//        content.sound = .default
//        
//        // 현재 날짜와 시간으로부터 1년 후 계산
//        let date = Date().addingTimeInterval(60 * 60 * 24 * 365) // 1년 후
//        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        
//        // UNCalendarNotificationTrigger를 사용한 트리거 설정
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        
//        // 알림 요청 생성
//        let request = UNNotificationRequest(identifier: "photoCheckNotification", content: content, trigger: trigger)
//        
//        // 알림 등록
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled for 1 year later.")
//            }
//        }
//    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 테스트"
        content.body = "10초 후 표시되는 알림입니다."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "TestNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for 10 seconds later.")
            }
        }
    }
}
