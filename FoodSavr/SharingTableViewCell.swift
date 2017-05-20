//
//  SharingTableViewCell.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class SharingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var isShared: UISwitch!
    @IBOutlet weak var groupName: UILabel!
    
    @IBAction func switchTapped(_ sender: Any) {
        if isShared.isOn {
            
        } else {
            
        }
    }
    
    func itemShared() {
        
    }
    
    
}
