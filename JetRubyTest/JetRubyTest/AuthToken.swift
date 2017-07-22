//
//  AuthToken.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct AuthToken {
    let token: String
    let type: String
    
    init(token: String, type: String) {
        self.token = token
        self.type = type
    }
}

extension AuthToken: Decodable {
    
    static func decode(_ json: JSON) -> Decoded<AuthToken> {
        return curry(AuthToken.init)
            <^> json <| "access_token"
            <*> json <| "token_type"
    }
}
