//
//  ViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/11/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIAlertViewDelegate {

    var alert = AlertDialogs()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    let deviceName = UIDevice.currentDevice().name
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    var loginURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    
    var company = ""
    var name = ""
    var logo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allAboutUI()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)

    }
    
    
    func allAboutUI() {
        btnLogin.backgroundColor = UIColor(hex: 0x0C46A0)
        btnLogin.setTitleColor(UIColor(hex: 0xffffff), forState: .Normal)
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1.5
        btnLogin.layer.borderColor = UIColor.whiteColor().CGColor
        
        scrollView.backgroundColor = UIColor(hex: 0x0C46A0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
        
    }
    
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() -> Void {
        println("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
        var buttonOrigin: CGPoint = self.btnLogin.frame.origin;
        var buttonHeight: CGFloat = self.btnLogin.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func hideKeyboard() {
        txtUsername.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        txtPassword.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    

    @IBAction func actionLogin(sender: AnyObject) {

        if ConnectionDetector.isConnectedToNetwork() {
            loginfunc()
        }else {
             alert.alertLogin("No Internet Connection", viewController: self)
        }
    }
    
    func loginfunc() {
        
        JsonToRealm.postLogin(["op":"staff_login",
                               "username":txtUsername.text,
                               "password":txtPassword.text.sha1(),
                               "device_id":deviceID,
                               "device_name":deviceName],
                                url: loginURL) { (code: String, msg: String, session_id: String, fName: String, lName: String, exhibitorId: String, eventID: String, companyId: String, companyName: String, eventTitle: String, eventLogo: String ) -> () in
            
            self.company = companyName
            self.name = ("\(fName) \(lName)")
            self.logo = eventLogo
                                    
            println("----->>> \(exhibitorId)")
            println("----->>> \(session_id)")
            println("----->>> \(eventID)")
            println("----->>> \(companyId)")
//            println("----->>> \()")
                                    
            if code == "error" {
                self.alert.alertLogin(msg, viewController: self)
            } else if code == "success" {
                var time = dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("toScanner", sender: self.btnLogin)
                }
            } else if code == "confirm" {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertView("Lead Tracker", message: msg, viewController: self)
                })
            } else if code == "Server Error" {
                    self.alert.alertLogin(msg, viewController: self)
            }
        
        }
    }
    
    func confirmLogin() {
        JsonToRealm.postLogin(["op":"staff_login",
            "username":txtUsername.text,
            "password":txtPassword.text.sha1(),
            "device_id":deviceID,
            "device_name":deviceName,
            "overwrite": 1],
            url: loginURL) { (code: String, msg: String, session_id: String, fName: String, lName: String, primaryExh: String, accessEnabled: String, companyName: String, eventCode: String, eventTitle: String, eventLogo: String ) -> () in
                
                self.company = companyName
                self.name = ("\(fName) \(lName)")
                self.logo = eventLogo
                
                var time = dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("toScanner", sender: self.btnLogin)
                }
        }
        
    }
    
    
    // ALERT WITH TEXTFIELD FOR iOs7 and iOs8
    func showAlertView(title: String, message: String, viewController: UIViewController) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("Yes")
        alert.addButtonWithTitle("No")
        alert.show()
    }
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            confirmLogin()
            break;
        case 1:
            println("CANCEL \(buttonIndex)")
            break;
        default: ()
        println("DEFAULT \(buttonIndex)")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toScanner" {
            let scannerVController : ScannerContainerViewController = segue.destinationViewController as! ScannerContainerViewController
            scannerVController.company = company
            scannerVController.name = name
            scannerVController.logo = ("http://ep.test.ozaccom.com.au/\(logo)")
            
        }
    }

    
}

