//
//  RightPopOver.swift
//  CloudstaffTeamManager
//
//  Created by t0tep on 4/27/15.
//  Copyright (c) 2015 CLOUDSTAFF. All rights reserved.
//

import UIKit

class PopOver: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    
    var root = UserInfoViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    var leftData = Array<String>()
    let rightData = ["Edit Questions", "About"]
//    let rightData = ["Clear TextField", "performSegue", "Refresh tableView"]
    
    var fromRoot = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Popover
        popoverPresentationController!.delegate = self
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if fromRoot == "left" {
            return leftData.count
        }else {
            return rightData.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        
        cell.textLabel?.text = rightData[row]
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.textColor = UIColor(hex: 0x0C46A0)
//        cell.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        self.preferredContentSize = CGSize(width:200,height:95)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        root.itemSelected(tableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text!)
        dismissViewControllerAnimated(true, completion: nil)
        root.viewWillAppear(true)
    }
    
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle{
        return .None
    }
    
    func presentationController(_: UIPresentationController, viewControllerForAdaptivePresentationStyle _: UIModalPresentationStyle)
        -> UIViewController?{
            return UINavigationController(rootViewController: self)
    }
    
}

