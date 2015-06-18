//
//  QuestionViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/21/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class ScreenSizeDetector: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    var arrayOfQuestion = ["q1", "q2", "q3", "q4", "q5"]
    @IBOutlet weak var bottonConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectScreenSize()
    }
    
    
    func detectScreenSize() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if UIScreen.mainScreen().nativeBounds.height == 480 {
                println("iPhone Classic")
            }else if UIScreen.mainScreen().nativeBounds.height == 960 {
                println("iPhone 4 or 4S")
//                bottonConst.constant = 122
            }else if UIScreen.mainScreen().nativeBounds.height == 1136 {
                println("iPhone 5 or 5S or 5C")
//                bottonConst.constant = 10
            }else if UIScreen.mainScreen().nativeBounds.height == 1334 {
                println("iPhone 6")
            }else if UIScreen.mainScreen().nativeBounds.height == 2208 {
                println("iPhone 6+")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfQuestion.count
    }
    
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: CellDetails = tableView.dequeueReusableCellWithIdentifier("questionCell") as! CellDetails
//        cell.question.text = arrayOfQuestion[indexPath.row]
//        cell.selectionStyle = UITableViewCellSelectionStyle.None
//        return cell
//    }
    
}
