//
//  PhotoData.swift
//  ImageCollectionForm
//
//  Created by 도현학 on 12/22/24.
//

import Foundation

struct PhotoData: Codable {
    var imagePath: String // 저장된 이미지의 경로
    var text: String      // 사진에 연결된 텍스트
}
