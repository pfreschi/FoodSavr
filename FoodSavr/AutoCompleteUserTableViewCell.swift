//
//  AutoCompleteUserTableViewCell.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/4/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class AutoCompleteUserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    var key: String = ""
}
