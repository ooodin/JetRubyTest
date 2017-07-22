//
//  SessionManager.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

protocol SessionManager {
    var delegate: SessionManagerDelegate? { get set }
    var tokenModel: AuthToken? { get }
    
    func setToken(token: AuthToken) -> Void
    func setCode(code: String) -> Void
    
    func loadAuthToken() -> Void
    func getAuthToken() -> Void
    func updateAuthToken(completion: (()->())?) -> Void
}

class SessionManagerImp: SessionManager {
    
    var delegate: SessionManagerDelegate?
    
    fileprivate(set) var tokenModel: AuthToken?
    fileprivate(set) var authCode: String?
    
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
    
    func loadAuthToken() {
        
        if let code = KeychainManager.loadAuthCode() {
            self.authCode = code
            
            if let token = KeychainManager.loadAuthToken() {
                self.tokenModel = AuthToken(token: token, type: "bearer")
                self.delegate?.updateData()
            } else {
                getAuthToken()
            }
        } else {
            AuthManagerImp().startDribbbleLogin()
        }
    }

    
    func getAuthToken() {
        updateAuthToken(completion: {
            self.delegate?.updateData()
        })
    }
    
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
            loadAuthToken()
        }
    }
}
