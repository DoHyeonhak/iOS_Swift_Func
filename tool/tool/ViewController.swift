import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let captureButton = UIButton(type: .system)
    let galleryButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 이미지 뷰 설정
        setupImageView()
        
        // 카메라 버튼 설정
        setupCaptureButton()
        
        // 갤러리 버튼 설정
        setupGalleryButton()
        
        // 공유 버튼 설정
        setupShareButton()
    }
    
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
    }
    
    func setupCaptureButton() {
        captureButton.setTitle("📷 카메라", for: .normal)
        captureButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.backgroundColor = UIColor.systemBlue
        captureButton.layer.cornerRadius = 10
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            captureButton.widthAnchor.constraint(equalToConstant: 150),
            captureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        captureButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
    }
    
    func setupGalleryButton() {
        galleryButton.setTitle("🖼 갤러리", for: .normal)
        galleryButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        galleryButton.setTitleColor(.white, for: .normal)
        galleryButton.backgroundColor = UIColor.systemGreen
        galleryButton.layer.cornerRadius = 10
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(galleryButton)
        
        NSLayoutConstraint.activate([
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryButton.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 10),
            galleryButton.widthAnchor.constraint(equalToConstant: 150),
            galleryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        galleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
    }
    
    func setupShareButton() {
        shareButton.setTitle("📤 공유하기", for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = UIColor.systemOrange
        shareButton.layer.cornerRadius = 10
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: galleryButton.bottomAnchor, constant: 10),
            shareButton.widthAnchor.constraint(equalToConstant: 150),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }
    
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "카메라 오류", message: "이 기기에서 카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(title: "갤러리 오류", message: "이 기기에서 갤러리를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func shareImage() {
        guard let image = imageView.image else {
            showAlert(title: "공유 오류", message: "공유할 이미지가 없습니다.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image, "이 이미지를 공유합니다!"], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // iPad 호환
        present(activityViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            print("이미지 선택 완료!")
        } else {
            showAlert(title: "이미지 오류", message: "이미지를 불러올 수 없습니다.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
