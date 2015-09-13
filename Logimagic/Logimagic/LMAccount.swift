//
//  LMAccount.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAccount: NSObject {
   
    var name: String = ""
    var type: String = ""
    var email: String = ""
    var password: String = ""
    
    override init() {
        super.init()
    }
    
    
    convenience init(_name: String, _type: String, _email: String, _password: String) {
        self.init()
        name = _name
        type = _type
        email = _email
        password = _password
    }
    
    
}
