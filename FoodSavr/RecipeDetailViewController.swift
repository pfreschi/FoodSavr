//
//  RecipeDetailViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 5/21/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
import Firebase
import Alamofire
import SwiftyJSON
import SwiftyStarRatingView
import Levenshtein




class RecipeDetailViewController: UIViewController {
    
    var currentRecipe = Recipe(key:"none", dictionary: Dictionary<String, AnyObject>())
    var storedRecipe : JSON = []
    var receiptRef : FIRDatabaseReference!
    var itemKey : String = ""
    
    var haveIngredients = Array<String>()
    var missingIngredients = Array<String>()
    
    @IBOutlet weak var recipePic: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeHaveIngredients: UITextView!
    @IBOutlet weak var recipeMissingIngredients: UITextView!
  
    @IBOutlet weak var recipeServings: UILabel!

    @IBOutlet weak var recipeRating: SwiftyStarRatingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showRecipeInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showRecipeInfo() {
        self.storedRecipe = JSON.parse(UserDefaults.standard.string(forKey: currentRecipe.id)!)
        print(storedRecipe)
        
        recipeName.text = storedRecipe["name"].stringValue
        print(storedRecipe["images"])
        var hostedLargeUrl = storedRecipe["images"][0]["hostedLargeUrl"]
        if hostedLargeUrl.stringValue != "" {
            recipePic.sd_setImage(with: URL(string: hostedLargeUrl.stringValue))
        } else if storedRecipe["images"][0]["hostedMediumUrl"] != "" {
            recipePic.sd_setImage(with: URL(string: storedRecipe["images"][0]["hostedMediumUrl"].stringValue))
        } else {
            recipePic.sd_setImage(with: URL(string: currentRecipe.smallImageUrls[0]))

        }
        
        
        recipeTime.text = storedRecipe["totalTime"].stringValue
        
        // adds relevant ingredients to Have and Missing
        differentiateIngredients()
        
        let combinedMissingIngredientsString = missingIngredients.joined(separator: "\r")
        recipeMissingIngredients.text = combinedMissingIngredientsString
        
        let combinedHavingIngredientsString = haveIngredients.joined(separator: "\r")
        recipeHaveIngredients.text = combinedHavingIngredientsString
        
        recipeServings.text = storedRecipe["numberOfServings"].stringValue + " people"
        
        let rating = storedRecipe["rating"].stringValue as NSString
        
        recipeRating.value = CGFloat.init(rating.floatValue)
        recipeRating.isUserInteractionEnabled = false
        
        
        

    }
    
    // fetch image from firebase storage
    func fetchImage(firUrl: String) -> UIImage {
        let url = URL(string: firUrl)
        let data = try! Data(contentsOf: url!)
        
        return UIImage(data: data)!
    }
    
    func differentiateIngredients() {
        let buffer = UserDefaults.standard.array(forKey: "inventory") as! Array<String>
        var allItemsInKitchen = Array<String>()
        for item in buffer {
            allItemsInKitchen.append(item.lowercased())
        }
        
        
        let longIngredients = storedRecipe["ingredientLines"].arrayObject as! Array<String>
        
        
        for (i, longIngredient) in longIngredients.enumerated() {
            var shortIngredient = currentRecipe.ingredients[i]
            shortIngredient = shortIngredient.replacingOccurrences(of: "organic", with: "")
            shortIngredient = shortIngredient.replacingOccurrences(of: "florets", with: "")
            
            var suggestion = Levenshtein.suggest(shortIngredient, list: allItemsInKitchen, ratio: 0.4, ignoreType: .all)
            if suggestion == nil {
                suggestion = ""
            }
            var rangeSug = ""
            for itemInKitchen in allItemsInKitchen {
                if itemInKitchen.range(of: shortIngredient) != nil {
                    rangeSug = itemInKitchen
                } else if shortIngredient.range(of: itemInKitchen) != nil {
                    rangeSug = itemInKitchen
                }
            }
            
            print("suggestion for : " + shortIngredient + "-----> " + suggestion!)
            print("range suggestion for : " + shortIngredient + "-----> " + rangeSug)
            
            
            if !haveIngredients.contains(longIngredient) && !missingIngredients.contains(longIngredient) {
                if suggestion != "" || rangeSug != "" || allItemsInKitchen.contains("organic " + shortIngredient.lowercased()) {
                    haveIngredients.append(longIngredient)
                    print("added to have (short is " + currentRecipe.ingredients[i] + " ) - long is " + longIngredient)
                } else {
                    missingIngredients.append(longIngredient)
                    print("added to missing (short is " + currentRecipe.ingredients[i] + " ) - long is " + longIngredient)
                }
            }

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showExternalRecipe" {
            let vc = segue.destination as! ExternalRecipeViewController
            vc.storedRecipe = self.storedRecipe

            
        }
    }

    
    
    
    
    
}
