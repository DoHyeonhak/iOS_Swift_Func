//
//  ViewController.swift
//  KakaoSDKTest
//
//  Created by 도현학 on 12/23/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 로그인 버튼 추가
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("카카오 로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.backgroundColor = .yellow
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.frame = CGRect(x: 50, y: 200, width: view.frame.width - 100, height: 50)
        loginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
    }

    // 로그인 버튼 액션
    @objc func kakaoLoginButtonTapped() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 실패: \(error)")
                } else {
                    print("카카오톡 로그인 성공")
                    self?.fetchUserInfo()
                }
            }
        } else {
            // 카카오 계정으로 로그인 (카카오톡 앱이 없을 경우)
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("카카오 계정 로그인 실패: \(error)")
                } else {
                    print("카카오 계정 로그인 성공")
                    self?.fetchUserInfo()
                }
            }
        }
    }

    // 사용자 정보 가져오기
    func fetchUserInfo() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error)")
            } else if let user = user {
                print("사용자 정보 가져오기 성공")
                print("닉네임: \(user.kakaoAccount?.profile?.nickname ?? "닉네임 없음")")
                print("이메일: \(user.kakaoAccount?.email ?? "이메일 없음")")
                print("프로필 이미지 URL: \(user.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? "없음")")
                
                // 사용자 정보를 UI 또는 서버에 활용 가능
                self.showAlert(title: "로그인 성공", message: "환영합니다, \(user.kakaoAccount?.profile?.nickname ?? "사용자")님!")
            }
        }
    }

    // 알림창 표시
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
