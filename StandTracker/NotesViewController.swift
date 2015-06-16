//
//  NotesViewController.swift
//  StandTracker
//
//  Created by t0tep on 6/15/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    let paramKey = NSUserDefaults.standardUserDefaults()
    var arrayOfDetail = ["First Name", "Last Name", "Company", "Position", "Mobile"]
//    var arrayOfInfo = Array<String>()
    var userID = ""
    
    var arrayOfInfo = ["Sample name", "Sample lastname", "sample Company", "Security", "0000 0 00 00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAboutUI()

    }
    
    func allAboutUI() {
        uiView.backgroundColor = UIColor(hex: 0x0C46A0)
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
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
    


}
