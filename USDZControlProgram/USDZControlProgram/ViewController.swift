import UIKit
import RealityKit

class ViewController: UIViewController {

    var arView: ARView!
    var usdzEntity: ModelEntity?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ARView 초기화
        arView = ARView(frame: self.view.bounds)
        arView.automaticallyConfigureSession = false // AR 비활성화
        view.addSubview(arView)

        // USDZ 파일 로드 및 제스처 추가
        loadUSDZModel()

        // 한 손가락 제스처 추가 (회전)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        arView.addGestureRecognizer(panGesture)

        // 두 손가락 제스처 추가 (줌)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        arView.addGestureRecognizer(pinchGesture)
    }

    func loadUSDZModel() {
        // USDZ 파일 경로 확인
        guard let usdzURL = Bundle.main.url(forResource: "pancakes", withExtension: "usdz") else {
            print("USDZ 파일을 찾을 수 없습니다.")
            return
        }

        do {
            // USDZ 모델 로드
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

            print("USDZ 모델 로드 및 초기 크기 설정 성공!")
        } catch {
            print("USDZ 파일 로드 실패: \(error)")
        }
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let entity = usdzEntity else { return }
        let translation = gesture.translation(in: arView)

        if gesture.state == .changed {
            // 회전 각도 계산 (Y축과 X축 기준)
            let angleX = Float(translation.y) * 0.01 // 위아래 드래그로 X축 회전
            let angleY = Float(translation.x) * 0.01 // 좌우 드래그로 Y축 회전

            // 현재 회전에 추가
            entity.transform.rotation *= simd_quatf(angle: angleX, axis: [1, 0, 0]) // X축 회전
            entity.transform.rotation *= simd_quatf(angle: angleY, axis: [0, 1, 0]) // Y축 회전

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
