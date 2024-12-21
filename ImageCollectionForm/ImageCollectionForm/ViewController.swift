//
//  ViewController.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {
    var selectedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSelectPhotoButton()
        setupSavedPhotosButton()
    }
    
    // 사진 선택 버튼
    func setupSelectPhotoButton() {
        let selectPhotoButton = UIButton(type: .system)
        selectPhotoButton.setTitle("Select Photos", for: .normal)
        selectPhotoButton.addTarget(self, action: #selector(presentPhotoPicker), for: .touchUpInside)
        selectPhotoButton.frame = CGRect(x: 20, y: 100, width: 200, height: 40)
        view.addSubview(selectPhotoButton)
    }
    
    // 저장된 사진 보기 버튼
    func setupSavedPhotosButton() {
        let savedPhotosButton = UIButton(type: .system)
        savedPhotosButton.setTitle("Saved Photos", for: .normal)
        savedPhotosButton.addTarget(self, action: #selector(showSavedPhotos), for: .touchUpInside)
        savedPhotosButton.frame = CGRect(x: 20, y: 160, width: 200, height: 40)
        view.addSubview(savedPhotosButton)
    }
    
    @objc func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10 // 최대 선택 가능 이미지 수
        config.filter = .images // 이미지 필터 설정
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func showSavedPhotos() {
        let savedVC = SavedPhotosViewController()
        navigationController?.pushViewController(savedVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true) // Picker 닫기
        selectedImages = [] // 선택된 이미지 초기화
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self?.selectedImages.append(image)
                            if self?.selectedImages.count == results.count {
                                self?.goToEditor()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func goToEditor() {
        guard !selectedImages.isEmpty else {
            print("No images selected!")
            return
        }
        let editorVC = StoryEditorViewController()
        editorVC.images = selectedImages
        navigationController?.pushViewController(editorVC, animated: true)
    }
}
