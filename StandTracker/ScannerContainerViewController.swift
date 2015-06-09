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
    
    var company = ""
    var name = ""
    
    var imageCache = [String : UIImage]()
    var logo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       allAboutUI()
        
        txtCompany.text = company
        txtOwner.text = name
        parseLogo()
        
    }
    
    func parseLogo() {
        
        imgEpLogo?.image = UIImage(named: "ep_logo")
        let urlString = logo
        var image = self.imageCache[urlString]
        
        println("----->>>>> \(urlString)")
        
        if( image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    println("--->> image \(image)")
                    
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
        btnMenu.hidden = true

    }
}
