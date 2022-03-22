//
//  ViewController.swift
//  Photos
//
//  Created by 백상휘 on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        40
    }
    
    //customCellIdentifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath)
        cell.backgroundColor = getRandomColor()
        
        return cell
    }
    
    private func getRandomColor() -> UIColor {
        UIColor(
            red: CGFloat(Float.random(in: 0...1)),
            green: CGFloat(Float.random(in: 0...1)),
            blue: CGFloat(Float.random(in: 0...1)),
            alpha: 1.0
        )
    }
}
