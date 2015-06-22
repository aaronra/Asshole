//
//  ScannerContainerViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/18/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class ScannerContainerViewController: UIViewController, SideBarDelegate {

    
    @IBOutlet weak var leftMenu: UIBarButtonItem!
    @IBOutlet weak var rightMenu: UIBarButtonItem!

    @IBOutlet weak var imgEpLogo: UIImageView!
    @IBOutlet var vcContainer: UIView!
    @IBOutlet weak var txtCompany: UILabel!
    @IBOutlet weak var txtOwner: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    var imageCache = [String : UIImage]()
    
    let paramKey = NSUserDefaults.standardUserDefaults()
    var postURL = "http://ep.test.ozaccom.com.au/app_content/ajax/stand_tracker.ashx"
    
    var sideBar:SideBar = SideBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        allAboutUI()
        
        self.navigationItem.leftBarButtonItem = nil
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let company = tags[4]
        let name = tags[5]
        
        txtCompany.text = company
        txtOwner.text = name
        parseLogo()
        
        sideBar = SideBar(sourceView: self.view, menuItems:
            ["Edit Question",
                "Signout"])
        sideBar.delegate = self
        
    }
    
    func detectDevice() {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.navigationItem.leftBarButtonItem = nil
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.navigationItem.rightBarButtonItem = nil
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Unspecified {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    

    @IBAction func menu(sender: AnyObject) {
        
        if sideBar.isSideBarOpen == true {
            sideBar.showSideBar(false)
        }else{
            sideBar.showSideBar(true)
        }
        
    }
    
    
    @IBAction func rightMenu(sender: AnyObject) {
        
        let optionOneText = "Edit Question"
        let optionTwoText = "Sign Out"
        let cancelButtonTitle = "Cancel"

        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let Edit = UIAlertAction(title: optionOneText, style: UIAlertActionStyle.Default) { (EditSelected) -> Void in
            println("Clear")
            self.performSegueWithIdentifier("toEditQuestion", sender: self)
            
        }
        
        let SignOut =  UIAlertAction(title: optionTwoText, style: UIAlertActionStyle.Default) { (SignOutSelected) -> Void in
            println("Save")
            self.showAlertSignOut("LeadTracker", message: "Are you sure you want to sign out?", viewController: self)
        }
        
        let Cancel = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel){ (CancelSelected) -> Void in
            println("Cancel")
        }
        
        actionsheet.addAction(Edit)
        actionsheet.addAction(SignOut)
        actionsheet.addAction(Cancel)

        
        if let popoverController = actionsheet.popoverPresentationController {
            popoverController.barButtonItem = sender as! UIBarButtonItem
        }
        
        self.presentViewController(actionsheet, animated: true, completion: nil)
        
    }
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            performSegueWithIdentifier("toEditQuestion", sender: self)
        } else if index == 1 {
            showAlertSignOut("LeadTracker", message: "Are you sure you want to sign out?", viewController: self)
        }
    }
    
    
    
    func parseLogo() {
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let logo = ("http://ep.test.ozaccom.com.au/\(tags[6])")

        imgEpLogo?.image = UIImage(named: "ep_logo")
        let urlString = logo
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgEpLogo.image = image
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }else {
            dispatch_async(dispatch_get_main_queue(), {
                self.imgEpLogo.image = image
            })
        }
    }
    
    func allAboutUI() {
        vcContainer.backgroundColor = UIColor(hex: 0x157bdb)
        txtCompany.textColor = UIColor.whiteColor()
        txtOwner.textColor = UIColor.whiteColor()
        
        var image = UIImage(named: "logoName")
        var imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 25)
        navigationItem.titleView = imageView
    }
    
    
    // ALERT WITH TEXTFIELD FOR iOs7 and iOs8
    func showAlertSignOut(title: String, message: String, viewController: UIViewController) {
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
            let paramValue = self.paramKey.stringForKey("params")
            let tags = paramValue!.componentsSeparatedByString(":")
            let exhID = tags[0]
            JsonToRealm.postAnswer(["op":"staff_logout", "exhibitor_id": exhID, "device_id": deviceID], url: self.postURL) { (status: String, msg: String) -> () in
            }
            performSegueWithIdentifier("toLogin", sender: self)
            break;
        case 1:
            break;
        default: ()
        println("DEFAULT \(buttonIndex)")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toBarScanner" {
            let barScanner : BarCodeScanner = segue.destinationViewController as! BarCodeScanner
            
        }else if segue.identifier == "toEditQuestion" {
            let navigationController  = segue.destinationViewController as! UINavigationController
            var editQuestion = navigationController.topViewController as! EditTableViewController

        }
    }
}
