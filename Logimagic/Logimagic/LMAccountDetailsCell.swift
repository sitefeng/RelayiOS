//
//  LMAccountDetailsCell.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

protocol LMAccountDetailsCellDelegate {
    func accountDetailsCell(cell: LMAccountDetailsCell, didFinishedEditingWithTitle titleString: String, value: String)
}


class LMAccountDetailsCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: LMAccountDetailsCellDelegate?;

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

    }

    
    func setupWithTitle(title: String, placeholderText: String?, isSecure: Bool) {
        
        titleLabel.text = title
        textField.placeholder = placeholderText
        textField.secureTextEntry = isSecure
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        
        var titleText = ""
        if self.titleLabel.text != nil {
            titleText = titleLabel.text!
        }
        
        self.delegate?.accountDetailsCell(self, didFinishedEditingWithTitle: titleText, value: self.textField.text!)
    }
    
}
