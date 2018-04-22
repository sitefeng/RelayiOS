//
//  LMQRScanViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/13/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import AVFoundation

class LMQRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var isPopupPresented: Bool = false
    
    var device: AVCaptureDevice!
    var session: AVCaptureSession!
    
    var output: AVCaptureMetadataOutput!
    var input: AVCaptureDeviceInput!
    
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var qrView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan QR"
        
        if (isPopupPresented) {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancelButtonPressed")
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        
        self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        self.session = AVCaptureSession()
        
        self.input = try? AVCaptureDeviceInput(device: device)
        self.session.addInput(self.input)
        
        self.output = AVCaptureMetadataOutput()
        self.session.addOutput(self.output)
        
        let queue: dispatch_queue_t = dispatch_queue_create("MyQueue", nil)
        self.output.setMetadataObjectsDelegate(self, queue: queue)
        
        let availableTypes: NSArray = self.output.availableMetadataObjectTypes
        
        if availableTypes.containsObject(AVMetadataObjectTypeQRCode) {
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            let alertVC = UIAlertController(title: "Cannot Read QR Code", message: "Error Occurred", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        
        self.captureLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.qrView.layer.addSublayer(self.captureLayer)
        
        self.session.startRunning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.captureLayer.frame = CGRect(x: 0, y: 0, width: self.qrView.bounds.width, height: self.qrView.bounds.height)
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if (metadataObjects != nil && metadataObjects.count > 0) {
            let metadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            let deviceIdString = metadata.stringValue
            self.stopQRSession()
            
            let authContext = LMAuthContext()
            authContext.addDeviceId(deviceIdString)
            
            if (!isPopupPresented) {
                let loginSelectVC = LMLoginSelectViewController(nibName: "LMLoginSelectViewController", bundle: nil)
                let loginNavVC = UINavigationController(rootViewController: loginSelectVC)
                self.presentViewController(loginNavVC, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    func stopQRSession() {
        self.session.stopRunning()
        self.session = nil
        self.captureLayer.removeFromSuperlayer()
    }
    
    
    func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
