//
//  USDZModal.swift
//  USDZControlProgram
//
//  Created by 도현학 on 12/23/24.
//

import UIKit
import RealityKit

class USDZModal: UIViewController {

    var arView: ARView!
    var usdzEntity: ModelEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupARView() // ARView 초기화
        setupBackButton() // 백 버튼 추가
        loadUSDZModel() // USDZ 파일 로드 및 제스처 추가

        // 한 손가락 제스처 추가 (회전)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        arView.addGestureRecognizer(panGesture)

        // 두 손가락 제스처 추가 (줌)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        arView.addGestureRecognizer(pinchGesture)
    }

    func setupARView() {
        // ARView 초기화
        arView = ARView(frame: .zero)
        arView.automaticallyConfigureSession = false // AR 비활성화
        arView.translatesAutoresizingMaskIntoConstraints = false
        // 배경 색 설정
        arView.environment.background = .color(.lightGray) // 회색 배경 설정
        view.addSubview(arView)

        // ARView 레이아웃 설정
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupBackButton() {
        // 백 버튼 생성
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .clear
        backButton.layer.cornerRadius = 10
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)

        // 버튼을 뷰에 추가
        view.addSubview(backButton)

        // 버튼 위치 설정 (ARView 위에 오버레이)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // page 닫기
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    // USDZ 파일 가져오기
    func loadUSDZModel() {
        guard let usdzURL = Bundle.main.url(forResource: "airplane", withExtension: "usdz") else {
            print("USDZ 파일을 찾을 수 없습니다.")
            return
        }
        do {
            // Load USDZ Model
            let entity = try ModelEntity.loadModel(contentsOf: usdzURL)
            usdzEntity = entity

            // 충돌 감지 활성화
            usdzEntity?.generateCollisionShapes(recursive: true)

            // 최소 크기로 초기화
            usdzEntity?.scale = [0.05, 0.05, 0.05] // 최소 축소 크기 설정

            // 앵커 추가
            let anchor = AnchorEntity(world: [0, 0, -0.5]) // 사용자 앞 0.5m 위치
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)

            print("Success!")
        } catch {
            print("Fail: \(error)")
        }
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let entity = usdzEntity else { return }

        // 화면의 크기 기반으로 회전 강도를 조절
        let viewWidth = arView.bounds.width
        let viewHeight = arView.bounds.height

        // 제스처의 이동량 가져오기
        let translation = gesture.translation(in: arView)

        if gesture.state == .changed {
            // 회전 각도 계산
            let angleY = Float(translation.x / viewWidth) * .pi // 좌우 드래그로 Y축 회전
            let angleX = Float(translation.y / viewHeight) * .pi // 위아래 드래그로 X축 회전 (부호 반전 제거)

            // 현재 회전에 새로운 회전 적용
            let rotationY = simd_quatf(angle: angleY, axis: [0, 1, 0]) // Y축 회전
            let rotationX = simd_quatf(angle: angleX, axis: [1, 0, 0]) // X축 회전
            entity.transform.rotation = rotationY * entity.transform.rotation * rotationX

            // 제스처 이동 초기화
            gesture.setTranslation(.zero, in: arView)
        }
    }

    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let entity = usdzEntity else { return }

        if gesture.state == .changed {
            // 현재 크기 가져오기
            let currentScale = entity.scale

            // 새로운 스케일 계산
            let pinchScale = Float(gesture.scale)
            let newScale = currentScale * pinchScale

            // 크기 제한 (최소 0.05, 최대 2.0)
            entity.scale = [max(0.05, min(newScale.x, 2.0)),
                            max(0.05, min(newScale.y, 2.0)),
                            max(0.05, min(newScale.z, 2.0))]

            // 제스처 스케일 초기화
            gesture.scale = 1.0
        }
    }
}
