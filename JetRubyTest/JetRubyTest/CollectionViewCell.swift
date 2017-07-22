//
//  CollectionViewCell.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var shot: Shot? {
        didSet {
            if let shot = shot {
                imageView.image = shot.image
                descriptionLabel.text = shot.description
            }
        }
    }
    
}
