import UIKit

class StoryEditorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    var images: [UIImage] = [] // 새로 추가된 이미지 배열
    var texts: [String] = [] // 새로 추가된 각 이미지에 대응하는 텍스트 배열
    var mainImageView: UIImageView!
    var thumbnailCollectionView: UICollectionView!
    var textField: UITextField!
    var currentIndex: Int = 0 // 현재 선택된 이미지의 인덱스
    var originalViewFrame: CGRect? // 원래 뷰의 프레임

    override func viewDidLoad() {
        super.viewDidLoad()
        texts = Array(repeating: "", count: images.count) // 텍스트 배열 초기화
        setupUI()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self) // 옵저버 해제
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

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        if originalViewFrame == nil {
            originalViewFrame = view.frame // 원래 뷰 프레임 저장
        }

        // 키보드가 나타날 때 텍스트 필드를 올리기
        let keyboardHeight = keyboardFrame.height
        let textFieldBottomY = textField.frame.maxY
        let overlap = textFieldBottomY - (view.frame.height - keyboardHeight)

        if overlap > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -overlap - 20 // 여유 공간 추가
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let originalFrame = originalViewFrame {
            UIView.animate(withDuration: 0.3) {
                self.view.frame = originalFrame
            }
        }
    }

    @objc func updateText(_ textField: UITextField) {
        texts[currentIndex] = textField.text ?? ""
    }

    @objc func saveAndExit() {
        var photoData: [PhotoData] = []

        // 새로 추가된 데이터를 저장
        for (index, image) in images.enumerated() {
            if let imageName = DataManager.shared.saveImage(image) {
                let text = texts.indices.contains(index) ? texts[index] : ""
                photoData.append(PhotoData(imagePath: imageName, text: text))
            }
        }

        // 기존 데이터는 유지하고 새 데이터를 병합하여 저장
        DataManager.shared.addNewData(photoData: photoData)

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
