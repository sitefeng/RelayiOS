//
//  LMFirebaseInterfacer.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import Firebase

class LMFirebaseInterfacer: NSObject {
    
    static let kDevicesURL = "https://login-magic.firebaseio.com/devices/"
   
    class func sendLoginInfo(deviceId: String, serviceType: String, username: String, password: String) {
        
        var ref = Firebase(url: kDevicesURL + deviceId)
        
        var dict = ["username": username,
                    "serviceType": serviceType,
                    "password": password]
        
        ref.updateChildValues(dict)
    }
    
    class func sendAutoLoginInfo(deviceId: String) {
        
        
    }
    
    
}
