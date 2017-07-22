//
//  Parameters.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

struct Parameters {
    
    struct dribbble {
        
        static let baseHostname = "api.dribbble.com"
        static let apiVersion = "v1"
        
        static let baseURL = "https://\(baseHostname)/\(apiVersion)/"
        static let authURL = "https://dribbble.com/oauth/authorize"
        static let tokenURL = "https://dribbble.com/oauth/token"
        static let redirectURL = "dribbbleShots://oauth-callback"
        
        static let clientID = "b971724ded25e31371cfb72ce713b74c713e9da4135c26c9d5f43cc58ee66eef"
        static let clientSecret = "82a9e629d93e7c059e5707c4b4af2a97f0bc69544aa50ebab454b66cbed14905"
        static let token = "2884012699128aee3ac4c9c3e8b25adb8129ac5020dca881163dd0c6a0a11d96"
    }
}
