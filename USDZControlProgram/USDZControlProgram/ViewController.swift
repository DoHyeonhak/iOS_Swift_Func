//
//  ViewController.swift
//  USDZControlProgram
//
//  Created by 도현학 on 12/23/24.
//

import UIKit

class ViewController: UIViewController {

    // 버튼 선언
    let openModalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        openModalButton.addTarget(self, action: #selector(openUSDZModal), for: .touchUpInside)

        view.addSubview(openModalButton)

        NSLayoutConstraint.activate([
            openModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openModalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func openUSDZModal() {
        // USDZModal 페이지 호출
        let usdzModalVC = USDZModal()

        // 모달 스타일 설정 (옵션)
        usdzModalVC.modalPresentationStyle = .fullScreen

        // 모달 표시
        present(usdzModalVC, animated: true, completion: nil)
    }
}
