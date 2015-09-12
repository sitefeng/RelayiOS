//
//  LCChatMessage.swift
//  LiveChat
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LCChatMessage: NSObject {
   
    var userId: String = ""
    var text: String = ""
    var time: NSDate = NSDate()
    
    convenience init(userId: String, text: String, time: NSDate) {
        self.init()
        self.userId = userId
        self.text = text
        self.time = time
    }
    
    convenience init(dict: [String: AnyObject]) {
        self.init()
        let userIdAny: AnyObject? = dict["userId"]
        let textAny: AnyObject? = dict["text"]
        let timeAny: AnyObject? = dict["time"]
        
        if userIdAny != nil {
            self.userId = userIdAny as! String
        }
        
        if textAny != nil {
            self.text = textAny as! String
        }
        
        if timeAny != nil {
            let timeDate = NSDate(ISO8601CompatibleString: timeAny as! String)
            self.time = timeDate
        }
        
    }
    
}
