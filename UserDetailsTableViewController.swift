//
//  UserDetailsTableViewController.swift
//  StandTracker
//
//  Created by t0tep on 6/16/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    
    
    var alert = AlertDialogs()
    
    @IBOutlet weak var lblFname: UILabel!
    @IBOutlet weak var lblLname: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    
    @IBOutlet weak var lblQues1: UILabel!
    @IBOutlet weak var lblQues2: UILabel!
    @IBOutlet weak var lblQues3: UILabel!
    @IBOutlet weak var lblQues4: UILabel!
    @IBOutlet weak var lblQues5: UILabel!
    
    @IBOutlet weak var txtAns1: UITextField!
    @IBOutlet weak var txtAns2: UITextField!
    @IBOutlet weak var txtAns3: UITextField!
    @IBOutlet weak var txtAns4: UITextField!
    @IBOutlet weak var txtAns5: UITextField!
    
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    let paramKey = NSUserDefaults.standardUserDefaults()
    let userInfoKey = NSUserDefaults.standardUserDefaults()
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        allAboutUI()
        displayUserDetails()
        displayQuestion()
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
            returnValue = 5
            

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
        
        lblFname.text = fname
        lblLname.text = lname
        lblCompany.text = company
        lblPosition.text = position
        lblMobile.text = mobile
        
        
    }
    
    
    func displayQuestion() {
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let q1 = tags[7]
        let q2 = tags[8]
        let q3 = tags[9]
        let q4 = tags[10]
        let q5 = tags[11]
        
        lblQues1.text = q1
        lblQues2.text = q2
        lblQues3.text = q3
        lblQues4.text = q4
        lblQues5.text = q5
        
    
    }
    
    
    
    @IBAction func done(sender: AnyObject) {
        
        let optionOneText = "Clear All"
        let optionTwoText = "Save"
        let optionThreeText = "Add Note"
        let cancelButtonTitle = "Cancel"
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let Clear = UIAlertAction(title: optionOneText, style: UIAlertActionStyle.Default) { (ClearSelected) -> Void in
            println("Clear")
            
            self.txtAns1.text = ""
            self.txtAns2.text = ""
            self.txtAns3.text = ""
            self.txtAns4.text = ""
            self.txtAns5.text = ""
            
        }
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
            
            JsonToRealm.postAnswer(["op":"update_user_track", "exhibitor_id": exhID, "session_id": sesID, "event_id": eveID, "company_id": comID, "user_id": self.userID, "answer_1": self.txtAns1.text, "answer_2": self.txtAns2.text, "answer_3": self.txtAns3.text, "answer_4": self.txtAns4.text, "answer_5": self.txtAns5.text, "notes": " "], url: self.postURL) { (status: String, msg: String) -> () in
                
                println("-------->>>>> \(status)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertView("Lead Tracker", message: "Successfully Saved!", viewController: self)
                })
            }
        }
        
        let Addnote =  UIAlertAction(title: optionThreeText, style: UIAlertActionStyle.Default) { (AddnoteSelected) -> Void in
            println("Addnote")
            self.performSegueWithIdentifier("toAddnotes", sender: self)
            
        }

        let Cancel = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel){ (CancelSelected) -> Void in
            println("Cancel")
        }
        
        actionsheet.addAction(Clear)
        actionsheet.addAction(Save)
        actionsheet.addAction(Addnote)
        actionsheet.addAction(Cancel)
        
        if let popoverController = actionsheet.popoverPresentationController {
            popoverController.barButtonItem = sender as! UIBarButtonItem
        }
        
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
    
    
    func hideKeyboard() {
        txtAns1.resignFirstResponder()
        txtAns2.resignFirstResponder()
        txtAns3.resignFirstResponder()
        txtAns4.resignFirstResponder()
        txtAns5.resignFirstResponder()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAddnotes" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let notesTableVC = navigationController.topViewController as! NotesTableViewController
            notesTableVC.userID = userID
            notesTableVC.ans1 = txtAns1.text
            notesTableVC.ans2 = txtAns2.text
            notesTableVC.ans3 = txtAns3.text
            notesTableVC.ans4 = txtAns4.text
            notesTableVC.ans5 = txtAns5.text
            
        }
    }
    
    




}
