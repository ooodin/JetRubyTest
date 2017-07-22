//
//  CollectionViewController.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit
import AVFoundation

protocol SessionManagerDelegate {
    func updateData() -> Void
}

class CollectionViewController: UICollectionViewController, SessionManagerDelegate {
    
    var shots: [Shot] = []
    var network: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network = NetworkManagerImp()
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView?.refreshControl = UIRefreshControl()
        collectionView?.refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        collectionView?.refreshControl?.beginRefreshing()
    
        let layout = collectionViewLayout as! DribbbleLayout
        layout.cellPadding = 5
        layout.delegate = self
        
        sessionManager.delegate = self
        sessionManager.loadAuthToken()
    }
    
    func updateData() {
        
        network?.getShots(success: { [weak self] json in
            let result = [Shot].decode(json)
            switch result {
            case let .success(shots):
                self?.setShots(shots)
            case let .failure(error):
                DialogManager.showErrorMessage(message: error.localizedDescription)
            }
            self?.collectionView?.refreshControl?.endRefreshing()
            
        }) { (error) in
            DialogManager.showErrorMessage(message: error.localizedDescription)
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    func setShots(_ newShots: [Shot]) {
        
        let temp = Array(newShots.filter{ !$0.animated }.prefix(50))
        
        if self.shots.count == 0 {
            self.shots = temp.sorted { $0.0.isCached.hashValue > $0.1.isCached.hashValue }
        } else {
            self.shots = temp
        }

        self.collectionView?.reloadData()
    }
    
    func loadImage(shot: Shot) {
     
        network?.loadImage(imageURL: shot.imageURL, completion: { (image) in
            DispatchQueue.main.async {
                shot.image = image
                self.collectionView?.reloadData() //TODO: Optimisation
                
//                if self.collectionView?.indexPathsForVisibleItems.contains(index) ?? false {
//                    self.collectionView?.reloadItems(at: [index])
//                }
            }
        })
    }
    
}

extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DribbbleCell", for: indexPath) as! CollectionViewCell
        let shot = shots[indexPath.item]
        
        if shot.image == nil {
            loadImage(shot: shot)
        }
        
        cell.shot = shot
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
