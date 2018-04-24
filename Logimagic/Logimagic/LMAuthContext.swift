//
//  LMAuthContext.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAuthContext: NSObject {
   
    let userDefaults = UserDefaults.standard
    
    let kDeviceIdsKey = "kDeviceIdsKey"

    
    var deviceIds: [String]! {
        set {
            userDefaults.set(newValue, forKey: kDeviceIdsKey)
            
        } get {
            return userDefaults.object(forKey: kDeviceIdsKey) as! [String]
        }
    }
    
    
    override init() {
        super.init()
        
        if userDefaults.object(forKey: kDeviceIdsKey) == nil {
            userDefaults.set([], forKey: kDeviceIdsKey)
        }

    }
    
    
    func addDeviceId(deviceId: String) {
        var idsArray = userDefaults.object(forKey: kDeviceIdsKey) as! [String]
        
        if !idsArray.contains(deviceId) {
            idsArray.append(deviceId)
            userDefaults.set(idsArray, forKey: kDeviceIdsKey)
        }
    }
    
    
    func removeDeviceId(deviceId: String) {
        let idsArray = userDefaults.object(forKey: kDeviceIdsKey) as! [String]
        
        let newArray = idsArray.filter({
            $0 != deviceId
        })

        userDefaults.set(newArray, forKey: kDeviceIdsKey)
    }
    
    
    
}
