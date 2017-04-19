//
//  KitchenItemsTableViewCell.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class KitchenItemsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet var itemPic: UIImageView!

    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var expiration: UILabel!
}
