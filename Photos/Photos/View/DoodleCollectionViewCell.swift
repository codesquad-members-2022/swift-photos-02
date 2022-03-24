//
//  DoodleCollectionViewCell.swift
//  PhotoApp
//
//  Created by Bumgeun Song on 2022/03/24.
//

import UIKit

class DoodleCollectionViewCell: UICollectionViewCell {
    static let identifier = "DoodleCollectionViewCell"
    static let imageSize = CGSize(width: 110, height: 50)
    
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
