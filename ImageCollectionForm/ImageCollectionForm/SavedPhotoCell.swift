//
//  SavedPhotoCell.swift
//  ImageCollectionForm
//

import UIKit

class SavedPhotoCell: UITableViewCell {
    var photoImageView: UIImageView!
    var textField: UITextField!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        photoImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        photoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(photoImageView)

        textField = UITextField(frame: CGRect(x: 100, y: 30, width: contentView.frame.width - 120, height: 40))
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
    }

    func configure(with data: PhotoData, at index: Int) {
        if let image = DataManager.shared.loadImage(from: data.imagePath) {
            photoImageView.image = image
        }
        textField.text = data.text
        textField.tag = index // 여기서 tag를 설정
    }
}
