import UIKit
import SceneKit

class SnowBallViewController: UIViewController {
    
    var sceneView: SCNView!
    var snowParticle: SCNParticleSystem!
    var ballNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        // SceneKit 뷰 설정
        sceneView = SCNView(frame: self.view.bounds)
        sceneView.backgroundColor = .black
        sceneView.scene = SCNScene() // Scene 초기화
        sceneView.allowsCameraControl = true
        self.view.addSubview(sceneView)
        
        // 스노우볼 생성
        setupSnowBall()
    }
    
    func setupSnowBall() {
        // 스노우볼 구체
        let ballGeometry = SCNSphere(radius: 2.0)
        
        // 테두리를 강조하기 위한 재질 설정
        ballGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.1) // 약간의 색상 추가
        ballGeometry.firstMaterial?.transparency = 0.8                                     // 투명도 설정
        ballGeometry.firstMaterial?.fresnelExponent = 2.5                                  // 테두리 강조
        ballGeometry.firstMaterial?.reflective.contents = UIColor.white                   // 약간의 반사광 추가
        ballGeometry.firstMaterial?.blendMode = .add                                      // 블렌드 모드 설정
        
        ballNode = SCNNode(geometry: ballGeometry)
        ballNode.position = SCNVector3(0, 0, 0)
        sceneView.scene?.rootNode.addChildNode(ballNode) // 스노우볼 노드 추가
        
        // 스노우볼 바닥
        let baseGeometry = SCNCylinder(radius: 2.5, height: 0.5)
        baseGeometry.firstMaterial?.diffuse.contents = UIColor.white
        let baseNode = SCNNode(geometry: baseGeometry)
        baseNode.position = SCNVector3(0, -2.5, 0)
        sceneView.scene?.rootNode.addChildNode(baseNode)
        
        // 눈 입자 시스템
        snowParticle = createSnowParticleSystem()
        let particleNode = SCNNode()
        particleNode.addParticleSystem(snowParticle)
        ballNode.addChildNode(particleNode)
        
        // 카메라 추가
        setupCamera()
    }
    
    func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 10)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
    }
    
    func createSnowParticleSystem() -> SCNParticleSystem {
        let particleSystem = SCNParticleSystem()
        particleSystem.particleColor = .white                     // 눈송이 색상
        particleSystem.birthRate = 100                            // 생성 속도
        particleSystem.emissionDuration = 10                      // 발사 지속 시간
        particleSystem.loops = true                               // 루프 설정
        particleSystem.particleSize = 0.02                        // 눈송이 크기
        particleSystem.particleVelocity = 1                       // 눈송이 속도
        particleSystem.particleVelocityVariation = 0.5            // 속도 변이
        particleSystem.emitterShape = SCNSphere(radius: 2.0)      // 구체 내부에서 방출
        particleSystem.birthLocation = .volume                   // 구체의 부피 내에서 생성
        particleSystem.particleLifeSpan = 3.0                     // 입자의 생명 주기
        particleSystem.particleLifeSpanVariation = 0.5            // 수명의 변이
        particleSystem.spreadingAngle = 180                       // 입자가 모든 방향으로 퍼짐
        particleSystem.isAffectedByGravity = false                // SceneKit 중력 효과 비활성화
        particleSystem.acceleration = SCNVector3(0, -0.5, 0)      // 눈 입자가 아래로 떨어지도록 중력 효과 추가
        
        return particleSystem
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 터치로 스노우볼 흔들기
        let spin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1)
        let repeatSpin = SCNAction.repeat(spin, count: 1)
        ballNode.runAction(repeatSpin)
        
        // 눈 입자 강도 증가
        snowParticle.birthRate = 500
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.snowParticle.birthRate = 100
        }
    }
}
