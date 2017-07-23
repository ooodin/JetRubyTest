//
//  NetworkManager.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import Alamofire
import Argo

protocol NetworkManager {
    func updateAuthToken(code: String, success: @escaping ((JSON) -> Void), failure: @escaping ((Error) -> Void)) -> Void
    func getShots(success: @escaping ((JSON) -> Void), failure: @escaping ((Error) -> Void)) -> Void
    func loadImage(imageURL: String, completion: @escaping ((UIImage)->Void)) -> Void
}

let imageCache = NSCache<AnyObject, AnyObject>()

class NetworkManagerImp: NetworkManager {
    
    fileprivate func request(_ target: URL, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, success: @escaping ((JSON) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let headersWithDefault = addDefaultHeadersTo(headers)
    
        Alamofire.request(target, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headersWithDefault)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { [weak self] response in
                
                let statusCode = response.response?.statusCode
                
                if statusCode == 401 {
                    sessionManager.updateAuthToken(completion: {
                        self?.request(target, method: method,
                                      parameters: parameters, headers: headers, success: success, failure: failure)
                    })
                    
                    return
                }
                
                switch response.result {
                case let .success(data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data)
                        success(JSON(json))
                    } catch let error {
                        failure(error)
                    }
                case let .failure(error):
                    failure(error)
                    DialogManager.showErrorMessage(message: error.localizedDescription)
                }
        }
    }
    
    private func addDefaultHeadersTo(_ headers: HTTPHeaders?) -> HTTPHeaders {
        
        var modifiedParams = headers ?? [:]
        
        if modifiedParams["Authorization"] == nil,
            let token = sessionManager.tokenModel {
            modifiedParams["Authorization"] = "\(token.type) \(token.token)"
        }
        
        return modifiedParams
    }
}

extension NetworkManagerImp {
    
    func updateAuthToken(code: String, success: @escaping ((JSON) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let tokenURL = URL(string: Parameters.dribbble.tokenURL)!
        let parameters: [String: Any] = [
            "client_id" : Parameters.dribbble.clientID,
            "client_secret" : Parameters.dribbble.clientSecret,
            "code" : code,
            "redirect_uri" : Parameters.dribbble.redirectURL,
            ]
        
        request(tokenURL, method: HTTPMethod.post,
                parameters: parameters, headers: nil, success: success, failure: failure)
    }
    
    func getShots(success: @escaping ((JSON) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let stringURL = "\(Parameters.dribbble.baseURL)shots/"
        let shotsURL = URL(string: stringURL)!
        
        request(shotsURL, method: HTTPMethod.get,
                parameters: nil, headers: nil, success: success, failure: failure)
    }
    
    func loadImage(imageURL: String, completion: @escaping ((UIImage)->Void)) {
        
        let target = URL(string: imageURL)!
        
        Alamofire.request(target, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                switch response.result {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: imageURL as AnyObject)
                        completion(image)
                    }
                case let .failure(error):
                    DialogManager.showErrorMessage(message: error.localizedDescription)
                }
        }
        
    }
    
}




