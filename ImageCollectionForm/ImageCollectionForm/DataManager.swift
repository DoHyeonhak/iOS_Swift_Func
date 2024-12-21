//
//  DataManager.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

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

    // MARK: - 데이터 저장 (병합)
    func saveData(photoData: [PhotoData]) {
        // 기존 데이터 불러오기
        var existingData = loadData()
        
        // 새로운 데이터 병합
        existingData.append(contentsOf: photoData)
        
        // 병합된 데이터 저장
        if let jsonData = try? JSONEncoder().encode(existingData) {
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
}
