//
//  CellDetails.swift
//  StandTracker
//
//  Created by t0tep on 5/21/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

class CellDetails: UITableViewCell {
    
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var txtDelegateDetails: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var txtAnswer: UITextField!

   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

