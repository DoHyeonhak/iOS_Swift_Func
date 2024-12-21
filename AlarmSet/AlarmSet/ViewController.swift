//시간, 분 단위
//import UIKit
//import UserNotifications
//
//class ViewController: UIViewController {
//    
//    let datePicker = UIDatePicker()
//    let notificationButton = UIButton(type: .system)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 알림 권한 요청
//        requestNotificationPermission()
//        
//        // UIDatePicker 설정
//        datePicker.datePickerMode = .time
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
//        self.view.addSubview(datePicker)
//        
//        // 알림 설정 버튼 추가
//        notificationButton.setTitle("알림 설정", for: .normal)
//        notificationButton.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 50, width: 150, height: 50)
//        notificationButton.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
//        self.view.addSubview(notificationButton)
//    }
//    
//    // 알림 권한 요청
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Notification permission granted.")
//            } else {
//                print("Notification permission denied: \(String(describing: error))")
//            }
//        }
//    }
//    
//    // 알림 설정
//    @objc func scheduleNotification() {
//        let selectedDate = datePicker.date
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: selectedDate)
//        
//        // 알림 트리거 설정
//        let content = UNMutableNotificationContent()
//        content.title = "설정된 알람"
//        content.body = "설정된 시간이 되었습니다!"
//        content.sound = .default
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let request = UNNotificationRequest(identifier: "TimeBasedNotification", content: content, trigger: trigger)
//        
//        // 알림 등록
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled for \(components.hour ?? 0):\(components.minute ?? 0).")
//            }
//        }
//    }
//}

// 년도 단위
//import UIKit
//import UserNotifications
//
//class ViewController: UIViewController {
//    
//    let datePicker = UIDatePicker()
//    let notificationButton = UIButton(type: .system)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // 알림 권한 요청
//        requestNotificationPermission()
//        
//        // UIDatePicker 설정
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
//        self.view.addSubview(datePicker)
//        
//        // 알림 설정 버튼 추가
//        notificationButton.setTitle("알림 설정", for: .normal)
//        notificationButton.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 50, width: 150, height: 50)
//        notificationButton.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
//        self.view.addSubview(notificationButton)
//    }
//    
//    // 알림 권한 요청
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Notification permission granted.")
//            } else {
//                print("Notification permission denied: \(String(describing: error))")
//            }
//        }
//    }
//    
//    // 알림 설정
//    @objc func scheduleNotification() {
//        let selectedDate = datePicker.date
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
//        
//        // 알림 트리거 설정
//        let content = UNMutableNotificationContent()
//        content.title = "설정된 알람"
//        content.body = "설정된 날짜와 시간이 되었습니다!"
//        content.sound = .default
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        let request = UNNotificationRequest(identifier: "DateBasedNotification", content: content, trigger: trigger)
//        
//        // 알림 등록
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled for \(components).")
//            }
//        }
//    }
//}

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    let notificationButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 권한 요청
        requestNotificationPermission()
        
        // UIDatePicker 설정
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 200)
        self.view.addSubview(datePicker)
        
        // 알림 설정 버튼 추가
        notificationButton.setTitle("알림 설정", for: .normal)
        notificationButton.frame = CGRect(x: view.frame.width / 2 - 75, y: datePicker.frame.maxY + 20, width: 150, height: 50)
        notificationButton.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)
        self.view.addSubview(notificationButton)
    }
    
    // 알림 권한 요청
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(String(describing: error))")
            }
        }
    }
    
    // 알림 설정
    @objc func scheduleNotification() {
        let selectedDate = datePicker.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        
        // 알림 트리거 설정
        let content = UNMutableNotificationContent()
        content.title = "알림이 설정되었습니다"
        content.body = "선택한 날짜와 시간에 알림이 울립니다!"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "DateAndTimeNotification", content: content, trigger: trigger)
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(components.year!)-\(components.month!)-\(components.day!) \(components.hour!):\(components.minute!).")
            }
        }
    }
}
