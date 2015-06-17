//
//  UserDetailsTableViewController.swift
//  StandTracker
//
//  Created by t0tep on 6/16/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        allAboutUI()
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
    
    
    
    func hideKeyboard() {
        txtAns1.resignFirstResponder()
        txtAns2.resignFirstResponder()
        txtAns3.resignFirstResponder()
        txtAns4.resignFirstResponder()
        txtAns5.resignFirstResponder()

    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        let optionOneText = "Clear"
        let optionTwoText = "Save"
        let optionThreeText = "Add Note"
        let cancelButtonTitle = "Cancel"
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let Clear = UIAlertAction(title: optionOneText, style: UIAlertActionStyle.Default) { (ClearSelected) -> Void in
            println("Clear")
        }
        let Save =  UIAlertAction(title: optionTwoText, style: UIAlertActionStyle.Default) { (SaveSelected) -> Void in
            println("Save")
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
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    
    




}
