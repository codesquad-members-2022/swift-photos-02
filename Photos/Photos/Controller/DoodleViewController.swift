//
//  DoodleViewController.swift
//  PhotoApp
//
//  Created by Bumgeun Song on 2022/03/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class DoodleViewController: UICollectionViewController {
    
    private var manager: DoodleManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(DoodleCollectionViewCell.self, forCellWithReuseIdentifier: DoodleCollectionViewCell.identifier)
        
        self.collectionView.backgroundColor = .gray
        self.navigationItem.title = "Doodles"
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.setRightBarButton(closeButton, animated: false)
        
        manager = DoodleManager(forResource: "doodle", withExtension: "json") {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return manager?.doodleImageDataCount ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoodleCollectionViewCell.identifier, for: indexPath) as? DoodleCollectionViewCell,
            let imageData = manager?[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        if let image = UIImage(data: imageData) {
            cell.setImage(image)
        }
    
        return cell
    }
}
