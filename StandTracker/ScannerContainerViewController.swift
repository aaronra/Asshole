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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       allAboutUI()
    }

    
    func allAboutUI() {
        vcContainer.backgroundColor = UIColor(hex: 0x0C46A0)
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x0C46A0)
        
        txtCompany.textColor = UIColor.whiteColor()
        txtOwner.textColor = UIColor.whiteColor()

    }
}
