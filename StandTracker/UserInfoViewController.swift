//
//  UserInfoViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/19/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var txtAnswer1: UITextField!
    @IBOutlet weak var txtAnswer2: UITextField!
    @IBOutlet weak var txtAnswer3: UITextField!
    @IBOutlet weak var txtAnswer4: UITextField!
    @IBOutlet weak var txtAnswer5: UITextField!
    
    var scannedData = ""
    
    var arrayOfDetail = ["First Name", "Last Name", "Company", "Position", "Mobile"]
//    var arrayOfInfo = Array<String>()
    var arrayOfInfo = ["Sample name", "Sample lastname", "sample Company", "Security", "0000 0 00 00"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        allAboutUI()
        
        txtAnswer1.delegate = self
        txtAnswer2.delegate = self
        txtAnswer3.delegate = self
        txtAnswer4.delegate = self
        txtAnswer5.delegate = self
        
        txtAnswer1.tag = 1
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if txtAnswer1.selected {
            println("sasasas")
        }else if txtAnswer2.selected {
            println("123345")
        }
        
        return true
    }
    
    func allAboutUI() {
        uiView.backgroundColor = UIColor(hex: 0x0C46A0)
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
    }
    
    @IBAction func back(sender: AnyObject) {
        performSegueWithIdentifier("toScanner", sender: self)
    }
    
    
    func itemSelected(selectedData: String){

        println("---->>>> \(selectedData)")

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayOfDetail.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CellDetails = tableView.dequeueReusableCellWithIdentifier("detailCell") as! CellDetails
        cell.txtLabel.text = arrayOfDetail[indexPath.row]
        cell.txtDelegateDetails.text = arrayOfInfo[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
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
        
        
        var buttonOrigin: CGPoint = self.txtAnswer2.frame.origin;
        var buttonHeight: CGFloat = self.txtAnswer2.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 68)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func hideKeyboard() {
//        txtQone.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        txtAnswer1.resignFirstResponder()
        txtAnswer2.resignFirstResponder()
        txtAnswer3.resignFirstResponder()
        txtAnswer4.resignFirstResponder()
        txtAnswer5.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }


    
}
