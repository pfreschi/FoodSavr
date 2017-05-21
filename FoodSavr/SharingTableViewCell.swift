//
//  SharingTableViewCell.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class SharingTableViewCell: UITableViewCell {

    var delegate : sharingDelegate!
    var itemName : String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isShared.setOn(UserDefaults.standard.bool(forKey: "\(itemName)sharing"), animated: animated)
    }

    @IBOutlet weak var isShared: UISwitch!
    @IBOutlet weak var groupName: UILabel!
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        let sharingSwitch = sender
       
        delegate.sharingSwitchTapped(cell: self, isSwitchOn: sharingSwitch.isOn)
       
    }
    
    
}
