//
//  RecipeTableViewCell.swift
//  FoodSavr
//
//  Created by Peter Freschi on 5/3/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell : UITableViewCell {
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
