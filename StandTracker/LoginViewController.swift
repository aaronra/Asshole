//
//  ViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/11/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var alert = AlertDialogs()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    
    let secureID = "manager"
    let deviceName = UIDevice.currentDevice().name
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    var salt = "5d534e77a8c480d924bb75dd46a216bc08a587a7"
    
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
        performSegueWithIdentifier("toScanner", sender: self.btnLogin)
        if ConnectionDetector.isConnectedToNetwork() {
//            performSegueWithIdentifier("toScanner", sender: self.btnLogin)
        }else {
             alert.alertLogin("No Internet Connection", viewController: self)
        }
        
    }
    
    func loginfunc() {
        JsonToRealm.postLogin(["username":txtUsername.text,
            "password":(salt+txtPassword.text).sha1(),
            "secureID":secureID.md5,
            "devicename": deviceName,
            "deviceID": deviceID],
            url: "http://10.1.100.69:90/clients/login.json") { (code: Int, msg: String, sessionID: String, clientID: String) -> () in
                
                if code == 500 {
                    println(msg)
                    self.alert.alertLogin(msg, viewController: self)
                } else if code == 200 {
                    if msg == "You are currently logged in from your iPhone Simulator. Logging in on this device will log you out from your other device. Would you like to proceed?" {
                        self.alert.overWrite(msg, viewController: self)
                    }else {
                        var time = dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_SEC))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("toScanner", sender: self.btnLogin)
                        }
                        println("-------->>>>>> \(msg)")
                    }
                }else {
                    println("ERROR")
                }
        }
    }
    
    
}

