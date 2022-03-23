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
    var thumbnailsCount: Int {
        thumbnails.count
    }
    
    private var phAssets = [PHAsset]()
    
    subscript(index: Int) -> UIImage? {
        guard 0 <= index, index < thumbnails.count else { return nil }
        return thumbnails[index]
    }
    
    init() {
    }
    
    private func checkAuthorization(_ completionHandler: @escaping (Bool)->Void) {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized else {
            completionHandler(true)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            completionHandler(status == .authorized)
        }
    }
    
    private func getFetchResult() {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        let resultCount = result.count
        
        phAssets = (0..<resultCount).compactMap { index in
            result.object(at: index)
        }
    }
    
    func getThumbnailImages(_ completionHandler: @escaping ()->Void) {
        checkAuthorization { [weak self] granted in
            guard let self = self else { return }
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
}
