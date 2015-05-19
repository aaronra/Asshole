//
//  UserInfoViewController.swift
//  StandTracker
//
//  Created by t0tep on 5/19/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    
    @IBOutlet var uiView: UIView!

    
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

}
