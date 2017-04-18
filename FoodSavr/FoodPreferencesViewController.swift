//
//  FoodPreferencesViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/8/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class FoodPreferencesViewController : UITableViewController{
    
    // includes allergies and diet
    var options = [
        ["Dairy", "Egg", "Gluten", "Peanut", "Seafood", "Sesame", "Soy", "Sulfite", "Tree Nut", "Wheat"],
        ["Lacto vegetarian", "Ovo vegetarian", "Pescetarian", "Vegan", "Vegetarian"]
    ]
    var sections = ["Allergies", "Diet Options"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell;
        
        cell.textLabel?.text = options[indexPath.section][indexPath.row]
        return cell
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int  {
        return sections.count
    }
    
}

