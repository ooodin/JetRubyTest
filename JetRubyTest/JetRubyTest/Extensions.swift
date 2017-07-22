//
//  Extensions.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 20/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

extension URL {
    
    static func withParameters(_ baseURL: String, parameters: [String:Any]) -> URL? {
        if parameters.count > 0 {
            var url = "\(baseURL)?"
            for (key, value) in parameters {
                url = url + "&\(key)=\(value)"
            }
            
            return URL(string: url)
        }
        
        return URL(string: baseURL)
    }
    
    func valueOf(queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }

}
