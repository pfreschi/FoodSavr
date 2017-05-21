//
//  BorderedButton.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/13/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit

class BorderedButton: UIButton {
    
    var myValue: Int
    
    override init(frame: CGRect) {
        // set myValue before super.init is called
        self.myValue = 0
        
        super.init(frame: frame)
        
        // set other operations after super.init, if required
    }
    
    required init?(coder aDecoder: NSCoder) {
        // set myValue before super.init is called
        self.myValue = 0
        
        super.init(coder: aDecoder)
        
        // set other operations after super.init if required
        layer.borderWidth = 2.5
        layer.borderColor = currentTitleColor.cgColor
        layer.cornerRadius = 15.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
