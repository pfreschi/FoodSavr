//
//  CustomProductCell.swift
//  
//
//  Created by Xiaowen Feng on 4/17/17.
//
//

import UIKit

class CustomProductCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var itemPic: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var addedby: UILabel!
    
    @IBOutlet weak var expirtaion : UILabel!
    
    


}
