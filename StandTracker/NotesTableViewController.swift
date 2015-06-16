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

    
//    var arrayOfDetail = ["First Name", "Last Name", "Company", "Position", "Mobile"]
    var arrayOfInfo = ["Sample name", "Sample lastname", "sample Company", "Security", "0000 0 00 00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        populateDetails()
        
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

    
    func populateDetails() {
        
        txtFname.text = arrayOfInfo[0]
        txtLname.text = arrayOfInfo[1]
        txtCompany.text = arrayOfInfo[2]
        txtPosition.text = arrayOfInfo[3]
        txtMobile.text = arrayOfInfo[4]
    }
    
    func hideKeyboard() {
        txtAddNote.resignFirstResponder()
    }

    
}
