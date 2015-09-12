//
//  LCMainChatViewController.swift
//  LiveChat
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LCMainChatViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var drawScrollView: UIScrollView!
    
    var drawRec = UIPanGestureRecognizer()
    var scrollRec = UIPanGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chat"
        
        drawScrollView.backgroundColor = UIColor.blackColor()
        
        // DrawRec. Use only one finger to draw
        drawRec.addTarget(self, action: "drawed:")
        drawRec.maximumNumberOfTouches = 1
        drawRec.delegate = self
        self.drawScrollView.addGestureRecognizer(drawRec)
        
        // ScrollRec. Use 2 fingers to scroll down
        scrollRec.addTarget(self, action: "scrolled:")
        scrollRec.minimumNumberOfTouches = 2
        scrollRec.delegate = self
        self.drawScrollView.addGestureRecognizer(scrollRec)
        
    }
    
    
    func drawed(rec: UIPanGestureRecognizer) {
        if (rec.state == UIGestureRecognizerState.Began) {
            
            
            
        } else if (rec.state == UIGestureRecognizerState.Changed) {
            
            
            
        } else if (rec.state == UIGestureRecognizerState.Ended) {
            
            
        }
        
    }
    
    
    func scrolled(rec: UIPanGestureRecognizer) {
        
        
        
    }
    
    
    
}
