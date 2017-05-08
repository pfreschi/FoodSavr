//
//  RecipeViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/21/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Alamofire
import SDWebImage

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    struct Recipe {
        var title : String
        var pic : String
    }
    
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func recipesSavedSwitch(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("recipes selected")
        case 1:
            print("saved selected")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipes.append(Recipe(title: "Chicken Jambalaya", pic: "http://www.seriouseats.com/images/2017/02/20170217-jambalaya-vicky-wasik-23.jpg"))
        recipes.append(Recipe(title: "Weeknight Party Snacks", pic: "http://images.radiotimes.com/namedimage/Improve_your_mood_with_feel_good_food.jpg?quality=85&mode=crop&width=620&height=374&404=tv&url=/uploads/images/original/79860.jpg"))
        recipes.append(Recipe(title: "Herb-Crusted Salmon with Chickpeas", pic: "http://betheme.muffingroupsc.netdna-cdn.com/be/goodfood/wp-content/uploads/2016/06/home_goodfood_flatbox1.jpg"))
        recipes.append(Recipe(title: "Spring Rolls with Jalapeno Peppers", pic: "https://eat24-files-live.s3.amazonaws.com/cuisines/v4/thai.jpg?Signature=9CcWLEAisRnKb06Z91EX%2BCrE5Nk%3D&Expires=1493966846&AWSAccessKeyId=AKIAIEJ2GCCJRT63TBYA"))
        recipes.append(Recipe(title: "Tasty Pomegranate Salad", pic: "https://static.pexels.com/photos/5938/food-salad-healthy-lunch.jpg"))
        recipes.append(Recipe(title: "Butter Chicken", pic: "http://mehfilbestcuisine.com/wp-content/uploads/2015/12/food-wide-wallpaper-334729.jpg"))
        recipes.append(Recipe(title: "Green Pepper and Olive Pizza", pic: "http://www.wallpapers-web.com/data/out/82/4454160-food-wallpapers.jpg"))
        
        
        
    
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        

        
        
        // gather info from cloud functions result
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredRecipes.count
        }
        
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(
        withIdentifier: "Cell",
        for: indexPath) as! RecipeTableViewCell
        let row = indexPath.row
        
        if isSearching {
            cell.recipeTitle.text = filteredRecipes[row].title
            cell.recipeImage.sd_setImage(with: URL(string: filteredRecipes[row].pic), placeholderImage: UIImage(named: "genericrecipe"))
            
        } else {
            cell.recipeTitle.text = recipes[row].title
            cell.recipeImage.sd_setImage(with: URL(string: recipes[row].pic), placeholderImage: UIImage(named: "genericrecipe"))

        }
        

        cell.recipeImage.contentMode = .center
        cell.recipeImage.alpha = 0.8
        // TODO: add spacing between recipes, this doesn't work below
        /*
        cell.view.layer.masksToBounds = true
        cell.view.layer.borderColor = UIColor.white.cgColor
        cell.view.layer.borderWidth = 9.0
        */
        
        
        // this blur is too blurred and dark
        /*
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = cell.recipeImage.frame
 
        cell.recipeImage.addSubview(blurView)
        */
        
        return cell

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredRecipes = recipes.filter({ recipe in
                return recipe.title.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }

    
    
}


