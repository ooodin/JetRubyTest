//
//  SessionManager.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

protocol SessionManager {
    var tokenModel: AuthToken? { get }
    var authCode: String? { get }
    
    func setToken(token: AuthToken) -> Void
    func setCode(code: String) -> Void
    func updateAuthToken(completion: (()->())?) -> Void
}

class SessionManagerImp: SessionManager {
    
    private(set) var tokenModel: AuthToken?
    private(set) var authCode: String?
    
    init() {
        loadFromKeychain()
    }
    
    fileprivate func loadFromKeychain() {
        
        if let code = KeychainManager.loadAuthCode() {
            self.authCode = code
            
            if let token = KeychainManager.loadAuthToken() {
                self.tokenModel = AuthToken(token: token, type: "bearer")
            } else {
                updateAuthToken(completion: nil)
            }
        } else {
            AuthManagerImp().startDribbbleLogin()
        }
    }
    
    func setToken(token: AuthToken) {
        self.tokenModel = token
        KeychainManager.saveAuthToken(token: token.token)
    }
    
    func setCode(code: String) {
        self.authCode = code
        KeychainManager.saveAuthCode(code: code)
    }
    
}

extension SessionManagerImp {
    
    func updateAuthToken(completion: (()->())?) {
        
        let network = NetworkManagerImp()
        
        if let code = authCode {
            network.updateAuthToken(code: code, success: { [weak self] json in
                let result = AuthToken.decode(json)
                switch result {
                case let .success(tokenModel):
                    self?.setToken(token: tokenModel)
                    completion?()
                case let .failure(error):
                    DialogManager.showErrorMessage(message: error.localizedDescription)
                }
                
                }, failure: { error in
                    DialogManager.showErrorMessage(message: error.localizedDescription)
            })
        } else {
            loadFromKeychain()
        }
    }
}
