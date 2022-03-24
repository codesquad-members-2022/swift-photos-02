//
//  PhotoThumbnailManager.swift
//  Photos
//
//  Created by 백상휘 on 2022/03/22.
//

import Foundation
import Photos
import UIKit

class PhotoThumbnailManager: NSObject, PHPhotoLibraryChangeObserver {
    
    private let cachingImageManager = PHCachingImageManager()
    private let option: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        return option
    }()
    
    private var thumbnails = [UIImage]()
    private var phAssets = [PHAsset]()
    private let didUpdate: (() -> Void)?
    
    var thumbnailsCount: Int {
        thumbnails.count
    }
    
    subscript(index: Int) -> UIImage? {
        guard 0 <= index, index < thumbnails.count else { return nil }
        return thumbnails[index]
    }
    
    init(didUpdateHandler: @escaping (() -> Void)) {
        self.didUpdate = didUpdateHandler
        super.init()
        
        self.updateThumbnailState()
        PHPhotoLibrary.shared().register(self)
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
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        updateThumbnailState()
    }
    
    private func updateThumbnailState() {
        // 1. 인증을 비동기로 체크
        checkAuthorization { granted in
            guard granted else { return }
            
            // -> 2. PHAsset를 fetch해서 인스턴스 프로퍼티에 저장
            self.fetchPHAssets()
            
            // -> 3. fetch한 PHAsset에 대하여 캐싱을 시작
            self.startCaching()
            
            // -> 4. 캐싱된 Image를 fetch해서 프로퍼티에 저장
            self.fetchThumbnailImages()
        }
    }
    
    private func fetchPHAssets() {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        let resultCount = result.count
        
        phAssets = (0..<resultCount).compactMap { index in
            result.object(at: index)
        }
    }
    
    private func startCaching() {
        cachingImageManager.startCachingImages(
            for: phAssets,
            targetSize: PhotoCollectionViewCell.imageSize,
            contentMode: .aspectFill,
            options: option
        )
    }
    
    private func fetchThumbnailImages() {
        self.thumbnails.removeAll()
        
        for (index, asset) in self.phAssets.enumerated() {
            
            self.cachingImageManager.requestImage (
                for: asset,
                targetSize: PhotoCollectionViewCell.imageSize,
                contentMode: .aspectFill,
                options: option) { [weak self] image, _ in
                    if let image = image {
                        self?.thumbnails.append(image)
                    }
                    
                    guard let lastIndex = self?.phAssets.count else { return }
                    
                    if index == lastIndex-1 {
                        self?.didUpdate?()
                    }
                }
        }
    }
}
