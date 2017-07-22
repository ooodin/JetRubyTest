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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var shot: Shot? {
        didSet {
            if let shot = shot {
                titleLabel.text = shot.title
                descriptionLabel.text = shot.description
                if let image = shot.image {
                    imageView.image = image
                    activity.stopAnimating()
                }
            }
        }
    }

    override func prepareForReuse() {
        imageView.image = nil
        super.prepareForReuse()
    }
    
}
