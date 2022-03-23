//
//  ViewController.swift
//  Photos
//
//  Created by 백상휘 on 2022/03/21.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    lazy private var photoThumbnailManager: PhotoThumbnailManager = {
        let photoThumbnailManager = PhotoThumbnailManager()
        
        photoThumbnailManager.setImages {
            print("Set image complete!")
            DispatchQueue.main.async {
//                self.PhotoCollectionView.reloadData()
            }
        }
        
        return photoThumbnailManager
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoThumbnailManager.thumbnailsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell,
              let image = photoThumbnailManager[indexPath.row] else { return PhotoCollectionViewCell() }
        
        cell.setImage(image)
        
        return cell
    }
}
