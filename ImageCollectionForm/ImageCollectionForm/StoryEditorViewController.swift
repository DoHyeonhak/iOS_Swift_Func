//
//  StoryEditorViewController.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

import UIKit

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    var images: [UIImage] = [] // 선택된 이미지 배열
    var texts: [String] = [] // 각 이미지에 대응하는 텍스트 배열
    var mainImageView: UIImageView!
    var thumbnailCollectionView: UICollectionView!
    var textField: UITextField!
    var currentIndex: Int = 0 // 현재 선택된 이미지의 인덱스

    override func viewDidLoad() {
        super.viewDidLoad()
        texts = Array(repeating: "", count: images.count) // 텍스트 배열 초기화
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white
        setupSaveButton()
        setupMainImageView()
        setupTextInputField()
        setupThumbnailCollectionView()
    }

    func setupSaveButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAndExit))
        navigationItem.rightBarButtonItem = saveButton
    }

    func setupMainImageView() {
        mainImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.height * 0.5))
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = images.first
        view.addSubview(mainImageView)
    }

    func setupTextInputField() {
        let textFieldY = view.frame.height - 160
        textField = UITextField(frame: CGRect(x: 20, y: textFieldY, width: view.frame.width - 40, height: 40))
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text for current image"
        textField.text = texts[currentIndex]
        textField.addTarget(self, action: #selector(updateText(_:)), for: .editingChanged)
        textField.delegate = self // UITextFieldDelegate 설정
        view.addSubview(textField)
    }

    func setupThumbnailCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 10

        thumbnailCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 80), collectionViewLayout: layout)
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        view.addSubview(thumbnailCollectionView)
    }

    @objc func updateText(_ textField: UITextField) {
        texts[currentIndex] = textField.text ?? ""
    }

    @objc func saveAndExit() {
        var photoData: [PhotoData] = []

        for (index, image) in images.enumerated() {
            if let imageName = DataManager.shared.saveImage(image) {
                let text = texts.indices.contains(index) ? texts[index] : ""
                photoData.append(PhotoData(imagePath: imageName, text: text))
            }
        }

        // 새로운 데이터 병합하여 저장
        DataManager.shared.saveData(photoData: photoData)

        navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        mainImageView.image = images[currentIndex]
        textField.text = texts[currentIndex]
    }

    // UITextFieldDelegate: 리턴 키를 누르면 키보드 닫기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }
}
