import UIKit

class DataManager {
    static let shared = DataManager()
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    private let dataFile: URL

    private init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        dataFile = documentsDirectory.appendingPathComponent("photoData.json")
    }

    // MARK: - 데이터 저장
    func saveData(photoData: [PhotoData]) {
        if let jsonData = try? JSONEncoder().encode(photoData) {
            try? jsonData.write(to: dataFile)
        }
    }

    // MARK: - 데이터 불러오기
    func loadData() -> [PhotoData] {
        guard let jsonData = try? Data(contentsOf: dataFile),
              let photoData = try? JSONDecoder().decode([PhotoData].self, from: jsonData) else {
            return []
        }
        return photoData
    }

    // MARK: - 이미지 저장
    func saveImage(_ image: UIImage) -> String? {
        let imageName = "image_\(UUID().uuidString).jpg"
        let imagePath = documentsDirectory.appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            return imageName
        }
        return nil
    }

    // MARK: - 이미지 불러오기
    func loadImage(from imageName: String) -> UIImage? {
        let imagePath = documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    func addNewData(photoData: [PhotoData]) {
        var existingData = loadData() // 기존 데이터를 불러옴
        existingData.append(contentsOf: photoData) // 새 데이터를 추가
        if let jsonData = try? JSONEncoder().encode(existingData) {
            try? jsonData.write(to: dataFile)
        }
    }

    // MARK: - 이미지 삭제
    func deleteImage(at imagePath: String) {
        let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        do {
            try fileManager.removeItem(at: fileURL)
            print("이미지 삭제 완료: \(imagePath)")
        } catch {
            print("이미지 삭제 실패: \(error.localizedDescription)")
        }
    }
}
