import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경 색상 설정
        view.backgroundColor = UIColor.systemBlue
        
        // 중앙 텍스트 추가
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Snowball App!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.textColor = UIColor.white
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        // 텍스트 레이아웃 설정
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
