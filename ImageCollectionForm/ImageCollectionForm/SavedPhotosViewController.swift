//
//  SavedPhotosViewController.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

import UIKit

class SavedPhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var savedData: [PhotoData] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        savedData = DataManager.shared.loadData() // 로컬에서 데이터 불러오기
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true // 편집 모드에서 선택 가능
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SavedPhotoCell") // 셀 등록
        view.addSubview(tableView)

        // 삭제 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
    }

    @objc func toggleEditingMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPhotoCell", for: indexPath)
        let data = savedData[indexPath.row]
        cell.textLabel?.text = data.text
        if let image = DataManager.shared.loadImage(from: data.imagePath) {
            cell.imageView?.image = image
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 셀 높이
    }

    // 삭제 동작 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 데이터 삭제
            let photoToDelete = savedData[indexPath.row]
            DataManager.shared.deleteImage(at: photoToDelete.imagePath) // 로컬 이미지 파일 삭제
            savedData.remove(at: indexPath.row) // 데이터 배열에서 제거

            // 테이블 뷰 갱신
            tableView.deleteRows(at: [indexPath], with: .automatic)

            // 데이터 저장
            DataManager.shared.saveData(photoData: savedData)
        }
    }
}
