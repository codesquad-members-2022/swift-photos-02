//
//  PhotoThumbnailManager.swift
//  Photos
//
//  Created by 백상휘 on 2022/03/22.
//

import Foundation
import Photos
import UIKit

class PhotoThumbnailManager {
    
    private let cachingImageManager = PHCachingImageManager()
    
    private var thumbnails = [UIImage]()
    private var phAssets = [PHAsset]()
    
    var thumbnailsCount: Int {
        thumbnails.count
    }
    
    subscript(index: Int) -> UIImage? {
        guard 0 <= index, index < thumbnails.count else { return nil }
        return thumbnails[index]
    }
    
    private func checkAuthorization(_ completionHandler: @escaping (Bool)->Void) {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            // 인증이 있으면 바로 handler 실행
            completionHandler(true)
        } else {
            // 인증이 없는 경우, Alert로 요청
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                completionHandler(status == .authorized)
            }
        }
    }
    
    func setImages(_ completionHandler: @escaping () -> Void) {
        // 1. 인증을 비동기로 체크
        checkAuthorization { granted in
            guard granted else { return }
            
            // -> 2. PHAsset를 fetch해서 인스턴스 프로퍼티에 저장
            self.fetchPHAssets()
            
            // -> 3. PHAsset을 가지고 Image를 비동기로 fetch해서 프로퍼티에 저장
            self.fetchThumbnailImages(completionHandler)
        }
    }
    
    private func fetchPHAssets() {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        let resultCount = result.count
        
        phAssets = (0..<resultCount).compactMap { index in
            result.object(at: index)
        }
    }
    
    private func fetchThumbnailImages(_ completionHandler: @escaping () -> Void) {
        self.thumbnails.removeAll()
        for (index, asset) in self.phAssets.enumerated() {
            self.cachingImageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 100, height: 100),
                contentMode: .aspectFill,
                options: nil) { image, _ in
                    if let image = image {
                        self.thumbnails.append(image)
                    }
                    
                    if index == self.phAssets.count-1 {
                        completionHandler()
                    }
                }
        }
    }
}
