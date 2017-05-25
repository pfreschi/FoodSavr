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

class RecipeDetailViewController: UIViewController {
    
    var currentRecipe = Recipe(key:"none", dictionary: Dictionary<String, AnyObject>())
    var storedRecipe : JSON = []
    var receiptRef : FIRDatabaseReference!
    var itemKey : String = ""
    
    @IBOutlet weak var recipePic: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeHaveIngredients: UILabel!
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
        let ingredientLinesCombined = storedRecipe["ingredientLines"].arrayObject as! Array<String>
        let combinedString = ingredientLinesCombined.joined(separator: "\r")
        recipeMissingIngredients.text = combinedString
        
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
    
    func fetchRecipeDetails() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showExternalRecipe" {
            let vc = segue.destination as! ExternalRecipeViewController
            vc.storedRecipe = self.storedRecipe

            
        }
    }

    
    
    
    
    
}
