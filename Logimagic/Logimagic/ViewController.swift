//
//  ViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var device: AVCaptureDevice!
    var session: AVCaptureSession!
    
    var output: AVCaptureMetadataOutput!
    var input: AVCaptureDeviceInput!
    
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var qrView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        self.session = AVCaptureSession()
        
        self.input = AVCaptureDeviceInput(device: device, error: nil)
        self.session.addInput(self.input)
        
        self.output = AVCaptureMetadataOutput()
        self.session.addOutput(self.output)

        let queue: dispatch_queue_t = dispatch_queue_create("MyQueue", nil)
        self.output.setMetadataObjectsDelegate(self, queue: queue)
        
        let availableTypes: NSArray = self.output.availableMetadataObjectTypes
        
        if availableTypes.containsObject(AVMetadataObjectTypeQRCode) {
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            var alertVC = UIAlertController(title: "Cannot Read QR Code", message: "Error Occurred", preferredStyle: UIAlertControllerStyle.Alert)
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
            authContext.deviceId = deviceIdString
            
            let loginSelectVC = LMLoginSelectViewController(nibName: "LMLoginSelectViewController", bundle: nil)
            let loginNavVC = UINavigationController(rootViewController: loginSelectVC)
            self.presentViewController(loginNavVC, animated: true, completion: nil)
        }
    }

    
    func stopQRSession() {
        self.session.stopRunning()
        self.session = nil
        self.captureLayer.removeFromSuperlayer()
    }
    
}

