//
//  SettingsTableViewController.swift
//  CloudstaffTeamManager
//
//  Created by RitcheldaV on 10/2/15.
//  Copyright (c) 2015 CLOUDSTAFF. All rights reserved.
//


import UIKit


class NotesTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtAddNote: UITextView!
    
    @IBOutlet weak var txtFname: UILabel!
    @IBOutlet weak var txtLname: UILabel!
    @IBOutlet weak var txtCompany: UILabel!
    @IBOutlet weak var txtPosition: UILabel!
    @IBOutlet weak var txtMobile: UILabel!
    
    var userID = ""
    var ans1 = ""
    var ans2 = ""
    var ans3 = ""
    var ans4 = ""
    var ans5 = ""
    
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    let paramKey = NSUserDefaults.standardUserDefaults()
    let userInfoKey = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        allAboutUI()
        displayUserDetails()
        
    }
    
    func allAboutUI() {
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        if (section == 0) {
            returnValue = 5
        } else if (section == 1) {
            returnValue = 1
        }
        return returnValue
    }
    
    func displayUserDetails() {
        
        let userDetailValue = userInfoKey.stringForKey("userInfo")
        let tags = userDetailValue!.componentsSeparatedByString(":")
        let fname = tags[0]
        let lname = tags[1]
        let company = tags[2]
        let position = tags[3]
        let mobile = tags[4]
        
        txtFname.text = fname
        txtLname.text = lname
        txtCompany.text = company
        txtPosition.text = position
        txtMobile.text = mobile
        
        
    }
    
    
    func hideKeyboard() {
        txtAddNote.resignFirstResponder()
    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        let optionTwoText = "Save"
        let optionOneText = "Clear"
        let cancelButtonTitle = "Cancel"
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let Save =  UIAlertAction(title: optionTwoText, style: UIAlertActionStyle.Default) { (SaveSelected) -> Void in
            println("Save")
            
            let paramValue = self.paramKey.stringForKey("params")
            let tags = paramValue!.componentsSeparatedByString(":")
            let exhID = tags[0]
            let sesID = tags[1]
            let eveID = tags[2]
            let comID = tags[3]
            let comp =  tags[4]
            let name =  tags[5]
            let logo =  tags[6]
            
            JsonToRealm.postAnswer(["op":"update_user_track", "exhibitor_id": exhID, "session_id": sesID, "event_id": eveID, "company_id": comID, "user_id": self.userID, "answer_1": self.ans1, "answer_2": self.ans2, "answer_3": self.ans3, "answer_4": self.ans4, "answer_5": self.ans5, "notes": self.txtAddNote.text], url: self.postURL) { (status: String, msg: String) -> () in
                
                println("-------->>>>> \(status)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertView("Lead Tracker", message: "Successfully Saved!", viewController: self)
                })
            }
            
        }
        
        
        let Clear = UIAlertAction(title: optionOneText, style: UIAlertActionStyle.Default) { (ClearSelected) -> Void in
            self.txtAddNote.text = ""
        }
        
        
        let Cancel = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel){ (CancelSelected) -> Void in
            println("Cancel")
        }
        
        actionsheet.addAction(Save)
        actionsheet.addAction(Clear)
        actionsheet.addAction(Cancel)
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    
    // ALERT WITH TEXTFIELD FOR iOs7 and iOs8
    func showAlertView(title: String, message: String, viewController: UIViewController) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            performSegueWithIdentifier("toScanner", sender: self)
            break;
        default: ()
        println("DEFAULT \(buttonIndex)")
        }
    }
    

    
}
