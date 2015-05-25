//
//  AlertDialogs.swift
//  CloudstaffTeamManager
//
//  Created by t0tep on 3/13/15.
//  Copyright (c) 2015 CLOUDSTAFF. All rights reserved.
//

import UIKit
import Foundation

class AlertDialogs: NSObject, UIAlertViewDelegate {
    
    
    func alertLogin(apiMessage: String, viewController : UIViewController) {
        
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            println("8 above")
            var alertController = UIAlertController(title: "Cloudstaff Team Manager", message: apiMessage, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            viewController.presentViewController(alertController, animated: true, completion: nil)
        case .OrderedAscending:
            let alertView = UIAlertView(title: "Cloudstaff Team Manager", message: apiMessage, delegate: self, cancelButtonTitle: "OK")
            alertView.alertViewStyle = .Default
            alertView.show()
            println("8 below")
        }
    }
    
    
    func overWrite(apiMessage: String, viewController: UIViewController) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.message = apiMessage
        alert.addButtonWithTitle("OK")
        alert.addButtonWithTitle("Cancel")
        alert.show()
    }

    
    // ALERT WITH TEXTFIELD FOR iOs7 and iOs8
    func showAlertView(title: String, message: String, viewController: UIViewController) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = title
        alert.addButtonWithTitle("OK")

        alert.show()
    }
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            println("OK \(buttonIndex)")
            break;
        default: ()
        println("DEFAULT \(buttonIndex)")
        }
    }
    
}
