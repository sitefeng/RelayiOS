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
        
        let ref = Database.database().reference(fromURL: kDevicesURL + deviceId)
        
        let dict = ["username": username,
                    "serviceType": serviceType,
                    "password": password]
        
        ref.updateChildValues(dict)
    }
    
    class func getDeviceName(deviceId: String, callback: @escaping ((String) -> Void)) {
        
        let ref = Database.database().reference(fromURL: kDevicesURL + deviceId + "/name")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            if let valueString = snapshot.value as? String {
                callback(valueString)
            } else {
                callback("No Name Given")
            }
        })

    }
    
    
    class func getDeviceNameStatic(deviceId: String, callback: @escaping ((String) -> Void)) {
        
        let url = NSURL(string: kDevicesURL + deviceId + "/name.json")!
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (resp, data, error) -> Void in
            if error != nil {
                print("No Internet")
                callback("")
                return
            }
            
            let deviceName: AnyObject? = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            
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
