//
//  KeychainManager.swift
//  hotline
//
//  Created by ooodin on 19/05/2017.
//  Copyright © 2017 Semavin Artem. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let authTokenKey = "ios.ooodin.jetrubytest.token"
let authCodeKey = "ios.ooodin.jetrubytest.code"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainManager: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func saveAuthCode(code: String) {
        self.save(service: authCodeKey, data: code)
    }
    
    public class func loadAuthCode() -> String? {
        if let code = self.load(service: authCodeKey) as String? {
            return code
        }
        return nil
    }
    
    public class func saveAuthToken(token: String) {
        self.save(service: authTokenKey, data: token)
    }
    
    public class func loadAuthToken() -> String? {
        if let token = self.load(service: authTokenKey) as String? {
           return token
        }
        return nil
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: String, data: String) {
    
        guard let dataFromString: NSData = data.data(using: String.Encoding.utf8, allowLossyConversion: false) as NSData? else {
            return
        }
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: String) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}

