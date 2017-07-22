//
//  CollectionViewController.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewController: UICollectionViewController {
    
    var shots: [Shot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        collectionView?.refreshControl = UIRefreshControl()
        collectionView?.refreshControl?.addTarget(self, action: #selector(updateShots), for: .valueChanged)
        collectionView?.refreshControl?.beginRefreshing()
    
        let layout = collectionViewLayout as! DribbbleLayout
        layout.cellPadding = 5
        layout.delegate = self
        
        updateShots()
    }
    
    func updateShots() {
        
        let network = NetworkManagerImp()
        
        network.getShots(success: { [weak self] json in
            let result = [Shot].decode(json)
            switch result {
            case let .success(shots):
                self?.shots = shots
                self?.collectionView?.reloadData()
            case let .failure(error):
                DialogManager.showErrorMessage(message: error.localizedDescription)
            }
            self?.collectionView?.refreshControl?.endRefreshing()
            
        }) { (error) in
            DialogManager.showErrorMessage(message: error.localizedDescription)
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
}

extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DribbbleCell", for: indexPath) as! CollectionViewCell
        cell.shot = shots[indexPath.item]
        return cell
    }
    
}

extension CollectionViewController: DribbbleLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let heightSize: CGFloat = UIScreen.main.bounds.height/2
        let shot = shots[indexPath.item]
        if let image = shot.image {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
            return min(rect.height, heightSize)
        }
        
        return min(CGFloat(shot.height), heightSize)
    }

}
