//
//  BarCodeScanner.swift
//  StandTracker
//
//  Created by t0tep on 5/15/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
    @IBOutlet var vcScanner: UIView!
    @IBOutlet var uiview: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scannedData = ""
    var fetchedArray = Array<String>()
    var userID = ""
    let settKey = NSUserDefaults.standardUserDefaults()
    
    var fetchURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    
    let paramKey = NSUserDefaults.standardUserDefaults()
    let userInfoKey = NSUserDefaults.standardUserDefaults()
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode,
        AVMetadataObjectTypeInterleaved2of5Code,
        AVMetadataObjectTypeITF14Code,
        AVMetadataObjectTypeDataMatrixCode]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = supportedBarCodes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
//        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)

    }
    

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection:
        AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            println("NO QR Detected")
            scannedData = ""
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.filter({ $0 == metadataObj.type }).count > 0 {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                if scannedData != metadataObj.stringValue {
                    showAlertView("Scanned", message: metadataObj.stringValue, viewController: self)
                    scannedData = metadataObj.stringValue
                    captureSession?.stopRunning()
                }
            }
        }
    }
    
    func showAlertView(title: String, message: String, viewController: UIViewController) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = title
        alert.addButtonWithTitle("OK")
        alert.show()
        
        fetchData(message)
    
    }
    
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
        performSegueWithIdentifier("toUserInfo", sender: self)
            break;
        default: ()
        }
    }
    
    
    func fetchData(id: String) {
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let exhID = tags[0]
        let sesID = tags[1]
        let eveID = tags[2]
        let comID = tags[3]
        
        userID = id
        
        
        JsonToRealm.fetchData(["op":"view_user_track", "exhibitor_id": exhID, "session_id": sesID, "event_id": eveID, "company_id": comID, "user_id": id], url: fetchURL) { (status: String, msg: String, fName: String, lName: String, orgName: String, position: String, mobile: String, note1: String, note2: String, note3: String, note4: String, note5: String) -> () in
            self.fetchedArray.append(fName)
            self.fetchedArray.append(lName)
            self.fetchedArray.append(orgName)
            self.fetchedArray.append(position)
            self.fetchedArray.append(mobile)
            
            let userValue = self.userInfoKey.stringForKey("userInfo")
            self.userInfoKey.setValue("\(fName):\(lName):\(orgName):\(position):\(mobile)", forKey: "userInfo")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toUserInfo" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let userDetailController = navigationController.topViewController as! UserInfoViewController
            userDetailController.arrayOfInfo = fetchedArray
            userDetailController.userID = userID
            
        }
    }
    
    func allAboutUI() {
        vcScanner.backgroundColor = UIColor(hex: 0x0C46A0)
    }
    
}
