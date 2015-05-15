//
//  ViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/11/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.backgroundColor = UIColor(hex: 0xd3d3d3)
        btnLogin.setTitleColor(UIColor(hex: 0x000000), forState: .Normal)
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1.5
        btnLogin.layer.borderColor = UIColor.blackColor().CGColor
    }
}

