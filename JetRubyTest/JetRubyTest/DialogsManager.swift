//
//  DialogsManager.swift
//  JetRubyTest
//
//  Created by Artem Semavin on 21/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import UIKit

class DialogManager {
    
    class func showErrorMessage(message: String) {
        
        print("Error - ", message)
    }
    
    class func showErrorMessage(message: String, retry: (() -> Void)) {
        
        print("Error - ", message)
    }
    
}
