//
//  LMAddAccountCell.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAddAccountCell: UITableViewCell {

    static let kCellHeight: CGFloat = 75
    
    @IBOutlet weak var logoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoView.image = nil
    }

    
    func setupWithAccountType(type: String) {
        let imageName = type + "Logo"
        self.logoView.image = UIImage(named: imageName)
    }
    
    
}
