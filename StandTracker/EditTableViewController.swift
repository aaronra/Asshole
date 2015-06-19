//
//  EditTableViewController.swift
//  StandTracker
//
//  Created by t0tep on 6/17/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {
    
    
    @IBOutlet weak var txtQ1: UITextField!
    @IBOutlet weak var txtQ2: UITextField!
    @IBOutlet weak var txtQ3: UITextField!
    @IBOutlet weak var txtQ4: UITextField!
    @IBOutlet weak var txtQ5: UITextField!
    
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    let paramKey = NSUserDefaults.standardUserDefaults()
    let userInfoKey = NSUserDefaults.standardUserDefaults()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        allAboutUI()
        displayQuestion()
    }
    
    func allAboutUI() {
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
    }

    func displayQuestion() {
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let q1 = tags[7]
        let q2 = tags[8]
        let q3 = tags[9]
        let q4 = tags[10]
        let q5 = tags[11]
        
        txtQ1.text = q1
        txtQ2.text = q2
        txtQ3.text = q3
        txtQ4.text = q4
        txtQ5.text = q5
        
        
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        if (section == 0) {
            returnValue = 5
        } 
        return returnValue
    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        showAlertView("LeadTracker", message: "Update Questions?", viewController: self)

        
    }
    
    
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
            updateQuestion()
            performSegueWithIdentifier("toScanner", sender: self)
            break;
        case 1:
            break;
        default: ()
        println("DEFAULT \(buttonIndex)")
        }
    }
    
    
    func updateQuestion() {
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let exhID = tags[0]
        let sesID = tags[1]
        let eveID = tags[2]
        let comID = tags[3]
        let comp =  tags[4]
        let name =  tags[5]
        let logo =  tags[6]
        
        JsonToRealm.postQuestion(["op":"update_questions", "exhibitor_id": exhID, "session_id": sesID, "event_id": eveID, "company_id": comID, "question_1": txtQ1.text, "question_2": txtQ2.text, "question_3": txtQ3.text, "question_4": txtQ4.text, "question_5": txtQ5.text], url: postURL) { (status: String, msg: String, q1: String, q2: String, q3: String, q4: String, q5: String) -> () in
            
            println(status)
            
            dispatch_async(dispatch_get_main_queue(), {
                let paramValue = self.paramKey.stringForKey("params")
                self.paramKey.setValue("\(exhID):\(sesID):\(eveID):\(comID):\(comp):\(name):\(logo):\(q1):\(q2):\(q3):\(q4):\(q5)", forKey: "params")
                
            })
            
        }
        
    }
    
    func hideKeyboard() {
        
        txtQ1.resignFirstResponder()
        txtQ2.resignFirstResponder()
        txtQ3.resignFirstResponder()
        txtQ4.resignFirstResponder()
        txtQ5.resignFirstResponder()
    }
    
   


}
