//
//  CollectionViewCell.swift
//  Photos
//
//  Created by Bumgeun Song on 2022/03/22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    static let imageSize = CGSize(width: 100, height: 100)
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.addSubview(imageView)
        imageView.frame = self.bounds
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
