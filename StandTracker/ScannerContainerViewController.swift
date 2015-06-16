//
//  ScannerContainerViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/18/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class ScannerContainerViewController: UIViewController {


    @IBOutlet weak var imgEpLogo: UIImageView!
    @IBOutlet var vcContainer: UIView!
    @IBOutlet weak var txtCompany: UILabel!
    @IBOutlet weak var txtOwner: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    
    var imageCache = [String : UIImage]()
    
    let paramKey = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        allAboutUI()
        
        let paramValue = paramKey.stringForKey("params")
        let tags = paramValue!.componentsSeparatedByString(":")
        let company = tags[4]
        let name = tags[5]
        
        txtCompany.text = company
        txtOwner.text = name
        parseLogo()
        
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
        vcContainer.backgroundColor = UIColor(hex: 0x0C46A0)
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x0C46A0)
        
        txtCompany.textColor = UIColor.whiteColor()
        txtOwner.textColor = UIColor.whiteColor()
//        btnMenu.hidden = true

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toBarScanner" {
            let barScanner : BarCodeScanner = segue.destinationViewController as! BarCodeScanner
            
        }else if segue.identifier == "toAddQuestion" {
            let navigationController  = segue.destinationViewController as! UINavigationController
            var editQusstion = navigationController.topViewController as! EditQuestionViewController

        }
    }
}
