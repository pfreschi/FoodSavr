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
import SwiftyJSON
import SDWebImage

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
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
        let uid = UserDefaults.standard.string(forKey: "uid")
        FirebaseProxy.firebaseProxy.userRef.child(uid! + "/recipes").observe(.value, with: { (snapshot) in
            
            var newRecipes : [Recipe] = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let recipeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let recipe = Recipe(key: key, dictionary: recipeDict)
                        newRecipes.append(recipe)
                        
                        if (UserDefaults.standard.data(forKey: recipe.id) == nil) {
                            Alamofire.request("http://api.yummly.com/v1/api/recipe/" + recipe.id + "?_app_id=819b4bc4&_app_key=7566a720cd09d180c558599027c88ffd").responseString{ response in
                                if (response.result.value) != nil {
                                    let stringResult = response.result.value
                                    UserDefaults.standard.set(stringResult, forKey: recipe.id)
                                    
                                    UserDefaults.standard.synchronize()
                                }
                                
                                
                            }
                            
                            
                            
                        }

                        
                        
                        
                        
                    }
                }
                print(newRecipes)
                
                self.recipes = newRecipes
                self.tableView.reloadData()
                
                
                
                
                
            }
            
            
        }) { (error) in
            
            print("this is error" + error.localizedDescription)
        }
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        var picString = ""
        var keyForPic = ""
        
        if isSearching {
            cell.recipeTitle.text = filteredRecipes[row].recipeName
            
            picString = filteredRecipes[row].smallImageUrls[0]
            keyForPic = filteredRecipes[row].id
            
            
        } else {
            cell.recipeTitle.text = recipes[row].recipeName
            
            picString = recipes[row].smallImageUrls[0]
            keyForPic = recipes[row].id

        }
        
        // if a large image is possibly stored in user defaults
        if UserDefaults.standard.string(forKey: keyForPic) != nil {
            var storedRecipe = JSON.parse(UserDefaults.standard.string(forKey: keyForPic)!)
            
            var hostedLargeUrl = storedRecipe["images"][0]["hostedLargeUrl"]
            if hostedLargeUrl.stringValue != "" {
                picString = hostedLargeUrl.stringValue
            } else if storedRecipe["images"][0]["hostedMediumUrl"] != "" {
                picString = storedRecipe["images"][0]["hostedMediumUrl"].stringValue
            }
        }
        
        
        cell.recipeImage.sd_setImage(with: URL(string: picString), placeholderImage: UIImage(named: "genericrecipe"))
        
        
    
        //cell.recipeImage.alpha = 0.8
        
        cell.view.layer.masksToBounds = true
        cell.view.layer.borderColor = UIColor.white.cgColor
        cell.view.layer.borderWidth = 6.0
    
        
        
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
                return recipe.recipeName.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showRecipeDetail" {
            if let cell = sender as? UITableViewCell {
                let i = tableView.indexPath(for: cell)!.row
                let vc = segue.destination as! RecipeDetailViewController
                if isSearching {
                    vc.currentRecipe = self.filteredRecipes[i]
                } else {
                    vc.currentRecipe = self.recipes[i]
                }
            }
        }
    }


    
    
}


