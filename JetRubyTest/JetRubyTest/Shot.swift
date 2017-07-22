//
//  ShotModel.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit
import Argo
import Runes
import Curry

class Shot {
    let id: Int
    let animated: Bool

    let title: String
    let description: String?
    let imageURL: String
    
    let width: Int
    let height: Int
    
    var image: UIImage?
    let isCached: Bool
    
    init(id: Int, animated: Bool, title: String, description: String?, width: Int, height: Int, hidpi: String?, normal: String) {
        self.id = id
        self.animated = animated
        self.title = title
        self.description = description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        self.width = width
        self.height = height
        self.imageURL = hidpi ?? normal
        
        if let cachedImage = imageCache.object(forKey: self.imageURL as NSString) as? UIImage {
            self.image = cachedImage
            self.isCached = true
        } else {
            self.isCached = false
        }
    }
}

extension Shot: Decodable {
    static func decode(_ json: JSON) -> Decoded<Shot> {
        return curry(Shot.init)
            <^> json <| "id"
            <*> json <| "animated"
            <*> json <| "title"
            <*> json <|? "description"
            <*> json <| "width"
            <*> json <| "height"
            <*> json <|? ["images", "hidpi"]
            <*> json <|  ["images", "normal"]
    }
}




