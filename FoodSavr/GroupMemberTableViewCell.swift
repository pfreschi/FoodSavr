//
//  GroupMemberTableViewCell.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/18/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var allergy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
