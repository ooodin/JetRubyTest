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

struct Shot {
    let id: Int
    let animated: Bool
    
    let description: String?
    let hidpiURL: String?
    let normalURL: String?
    
    let width: Int
    let height: Int
    
    var image: UIImage?
    
    init(id: Int, animated: Bool, description: String?, width: Int, height: Int, hidpi: String?, normal: String?) {
        self.id = id
        self.animated = animated
        self.description = description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        self.width = width
        self.height = height
        self.hidpiURL = hidpi
        self.normalURL = normal
    }
    
}

extension Shot: Decodable {
    static func decode(_ json: JSON) -> Decoded<Shot> {
        return curry(Shot.init)
            <^> json <| "id"
            <*> json <| "animated"
            <*> json <|? "description"
            <*> json <| "width"
            <*> json <| "height"
            <*> json <|? ["images", "hidpi"]
            <*> json <|? ["images", "normal"]
    }
}
