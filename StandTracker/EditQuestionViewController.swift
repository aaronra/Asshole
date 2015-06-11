//
//  EditQuestionViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/26/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class EditQuestionViewController: UIViewController {
    
    

    @IBOutlet var uiView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    
    
    @IBOutlet weak var txtQ1: UITextField!
    @IBOutlet weak var txtQ2: UITextField!
    @IBOutlet weak var txtQ3: UITextField!
    @IBOutlet weak var txtQ4: UITextField!
    @IBOutlet weak var txtQ5: UITextField!
    var fetchedArray = Array<String>()

    
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    let paramKey = NSUserDefaults.standardUserDefaults()
    let userInfoKey = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAboutUI()
        displayQuestion()
        userBackData()
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
    
    func allAboutUI() {
        uiView.backgroundColor = UIColor(hex: 0x0C46A0)
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
        
        btnSave.hidden = true
        lblSave.hidden = true
    }
    
    func userBackData() {
        let paramValue = userInfoKey.stringForKey("userInfo")
        let tags = paramValue!.componentsSeparatedByString(":")
        let fname = tags[0]
        let lname = tags[1]
        let company = tags[2]
        let position = tags[3]
        let mobile = tags[4]
        
        fetchedArray.append(fname)
        fetchedArray.append(lname)
        fetchedArray.append(company)
        fetchedArray.append(position)
        fetchedArray.append(mobile)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToUser" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let userDetailController = navigationController.topViewController as! UserInfoViewController
            userDetailController.arrayOfInfo = fetchedArray
            
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
                
                userDetailController.q1 = q1
                userDetailController.q2 = q2
                userDetailController.q3 = q3
                userDetailController.q4 = q4
                userDetailController.q5 = q5
                
                dispatch_async(dispatch_get_main_queue(), {
                    let paramValue = self.paramKey.stringForKey("params")
                    self.paramKey.setValue("\(exhID):\(sesID):\(eveID):\(comID):\(comp):\(name):\(logo):\(q1):\(q2):\(q3):\(q4):\(q5)", forKey: "params")
                })
            
            }
            
        }else if segue.identifier == "backToScanner" {
            
            let scannerVC : ScannerContainerViewController = segue.destinationViewController as! ScannerContainerViewController
            
            println("esdgdfghsdrghdxzgdsf")
            
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    let paramValue = self.paramKey.stringForKey("params")
                    self.paramKey.setValue("\(exhID):\(sesID):\(eveID):\(comID):\(comp):\(name):\(logo):\(q1):\(q2):\(q3):\(q4):\(q5)", forKey: "params")
                })
                
            }
        }
    }


}
