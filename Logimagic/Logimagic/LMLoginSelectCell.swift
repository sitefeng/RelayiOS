//
//  LMLoginSelectCell.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMLoginSelectCell: UITableViewCell {

    static let kCellHeight: CGFloat = 64
    
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.typeImageView.layer.cornerRadius = self.typeImageView.frame.size.width/2
        self.typeImageView.layer.masksToBounds = true
    }

    func setupCell(name: String, type: String, email: String) {
        
        self.nameLabel.text = name
        self.emailLabel.text = email
        
        let image = UIImage(named: type + "Icon")
        self.typeImageView.image = image
    }
    
}
