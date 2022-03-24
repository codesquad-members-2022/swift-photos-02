//
//  CollectionViewCell.swift
//  Photos
//
//  Created by Bumgeun Song on 2022/03/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
