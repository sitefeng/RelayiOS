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
    
    class func getDeviceName(deviceId: String, callback: ((String) -> Void)) {
        
        var ref = Firebase(url: kDevicesURL + deviceId + "/name")
        
        ref.observeEventType(FEventType.Value, withBlock: { (snapshot) -> Void in
            let valueString = snapshot.value as? String
            
            if valueString != nil {
                callback(valueString!)
            } else {
                callback("No Name Given")
            }
            
        })
        
    }
    
    
    class func getDeviceNameStatic(deviceId: String, callback: ((String) -> Void)) {
        
        let url = NSURL(string: kDevicesURL + deviceId + "/device.json")!
        var request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (resp, data, error) -> Void in
            if error != nil {
                println("No Internet")
                callback("")
                return
            }
            
            let deviceName: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            let deviceNameStr = deviceName as? String
            if deviceNameStr != nil {
                
                callback(deviceNameStr!)
            } else {
                callback("")
            }
        }
        
    }
    
    
    class func sendAutoLoginInfo(deviceId: String) {
        
        
    }
    
    
}
