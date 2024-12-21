//
//  SavedPhotosViewController.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

import UIKit

class SavedPhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var savedData: [PhotoData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        savedData = DataManager.shared.loadData() // 로컬에서 데이터 불러오기
        setupTableView()
    }

    func setupTableView() {
        let tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
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
}
