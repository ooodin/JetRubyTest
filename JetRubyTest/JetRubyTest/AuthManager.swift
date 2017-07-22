//
//  AuthManager.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

protocol AuthManager {
    func startDribbbleLogin() -> Void
    func processOAuthResponse(url: URL) -> Void
}

class AuthManagerImp: AuthManager {
    
    func startDribbbleLogin() {
        
        let authURL = Parameters.dribbble.authURL
        let parameters: [String: Any] = [
            "client_id" : Parameters.dribbble.clientID,
            "redirect_uri" : Parameters.dribbble.redirectURL,
            "scope" : "public",
            "state" : ""
        ]
        
        if let authURL = URL.withParameters(authURL, parameters: parameters) {
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        }
    }
    
    func processOAuthResponse(url: URL) {
        
        if let code = url.valueOf(queryParamaterName: "code") {
            sessionManager.setCode(code: code)
            sessionManager.getAuthToken()
        }
    }
}
