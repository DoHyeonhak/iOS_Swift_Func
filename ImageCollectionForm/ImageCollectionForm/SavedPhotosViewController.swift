import UIKit

class SavedPhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var savedData: [PhotoData] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        savedData = DataManager.shared.loadData()
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedPhotoCell.self, forCellReuseIdentifier: "SavedPhotoCell")
        view.addSubview(tableView)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedPhotoCell", for: indexPath) as! SavedPhotoCell
        let data = savedData[indexPath.row]
        cell.configure(with: data, at: indexPath.row)
        cell.textField.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let photoToDelete = savedData[indexPath.row]
            DataManager.shared.deleteImage(at: photoToDelete.imagePath)
            savedData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            DataManager.shared.saveData(photoData: savedData)
        }
    }
    
    // UITextFieldDelegate: 리턴 키를 누르면 키보드 닫기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tag // 태그를 통해 인덱스 가져오기
        guard index >= 0, index < savedData.count else {
            print("Error: Index \(index) out of range for savedData.")
            return
        }

        // 텍스트를 업데이트하고 저장
        savedData[index].text = textField.text ?? ""
        print("Updated text for index \(index): \(savedData[index].text)")

        // 저장소에 변경사항 저장
        DataManager.shared.saveData(photoData: savedData)
    }
}
