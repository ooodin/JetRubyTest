//
//  DribbbleLayout.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

protocol DribbbleLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class DribbbleLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! DribbbleLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
   
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? DribbbleLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

class DribbbleLayout: UICollectionViewLayout {
    
    var cellPadding: CGFloat = 0
    var delegate: DribbbleLayoutDelegate!
    
    private var cache = [DribbbleLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    override class var layoutAttributesClass: AnyClass {
        return DribbbleLayoutAttributes.self
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
   
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = width
            
            let xOffset: CGFloat = 0
            var yOffset: CGFloat = 0
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                
                let width = columnWidth - (cellPadding * 2)
                let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + photoHeight + cellPadding
                
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: height)
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = DribbbleLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.photoHeight = photoHeight
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                
                yOffset = yOffset + height
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
