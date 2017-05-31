//
//  ItemDetailViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
import Firebase
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON

protocol sharingDelegate {
    func sharingSwitchTapped(cell : SharingTableViewCell, isSwitchOn : Bool)
}

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sharingDelegate {
    
    var currentItem = Item(key:"none", dictionary: Dictionary<String, AnyObject>())
    var userGroupsRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    var groups : [Group] = []
    var itemKey : String = ""
    var creatorName : String = ""
    
    var recipes = [Recipe]()

    
    
    @IBOutlet weak var itemPic: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var expirationDate: UILabel!

    @IBOutlet weak var added: UILabel!
    
    @IBOutlet weak var groupsTableview: UITableView!

    @IBOutlet weak var recipesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        userRef = FirebaseProxy.firebaseProxy.userRef
        groupsTableview.delegate = self
        groupsTableview.dataSource = self
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        getRecipes()
        showitemInfo()
        fetchGroups()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showitemInfo() {
        
        itemName.text = currentItem.name
        expirationDate.text = "Expire in \(expDate(days: currentItem.expirationDate))"
        itemPic.sd_setImage(with: URL(string: currentItem.pic), placeholderImage: UIImage(named: "genericinventoryitem"))
        setRoundBorder(img: itemPic)
        self.title = "Detail"
        added.text = "Added by \(self.creatorName)"
    }
    
    // fetch image from firebase storage
    func fetchImage(firUrl: String) -> UIImage {
        let url = URL(string: firUrl)
        let data = try! Data(contentsOf: url!)
        
        return UIImage(data: data)!
    }
    
    func expDate(days: Int) -> String {
        
        if (days < 30) {
            return "\(days)d"
        } else {
            return "\(days)d+"
        }
    }
    
    
    func setRoundBorder(img: UIImageView) {
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true;
        img.layer.borderWidth = 1.0;
        img.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor;
    }
    
    // MARK: - Table view data source
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == groupsTableview) {
            return groups.count
        } else {
            return recipes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == groupsTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sharingCell", for: indexPath) as! SharingTableViewCell
            let groupName = groups[indexPath.row].name
            cell.itemName = itemName.text!
            cell.groupName.text = groupName
            cell.delegate = self
            
            return cell

        } else {
            let recipeCell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
            let row = indexPath.row
            
            var picString = ""
            var keyForPic = ""
            

            recipeCell.recipeTitle.text = recipes[row].recipeName
                
            picString = recipes[row].smallImageUrls[0]
            keyForPic = recipes[row].id
                
            
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
            
            
            recipeCell.recipeImage.sd_setImage(with: URL(string: picString), placeholderImage: UIImage(named: "genericrecipe"))
            
            
            recipeCell.view.layer.masksToBounds = true
            recipeCell.view.layer.borderColor = UIColor.white.cgColor
            recipeCell.view.layer.borderWidth = 6.0
            
        
            return recipeCell
        }
        
    }
    
    func sharingSwitchTapped(cell : SharingTableViewCell, isSwitchOn : Bool) {
        let group = groups[(groupsTableview.indexPath(for: cell)?.row)!]
        UserDefaults.standard.set(isSwitchOn, forKey: "\(itemName.text!)sharing")
    
        UserDefaults.standard.synchronize()
        
        FirebaseProxy.firebaseProxy.markedAsShared(isShared: isSwitchOn, groupName: group.name, groupId: group.key, itemId: itemKey, members: group.users)
    }
    
    func fetchGroups() {
        var newGroups :[Group] = []
        userGroupsRef.child(FirebaseProxy.firebaseProxy.getCurrentUser()).observe(.childAdded , with: {(snapshot) in
            if let groupDict = snapshot.value as? Dictionary<String, AnyObject>{
                let key = snapshot.key
                let g = Group(key: key, dictionary: groupDict)
                newGroups.append(g)
            }
            
            self.groups = newGroups
            self.groupsTableview!.reloadData()
        })
        
    }
    
    func getRecipes() {
    
        let uid = UserDefaults.standard.string(forKey: "uid")
        FirebaseProxy.firebaseProxy.userRef.child(uid! + "/recipesForItems/\(currentItem.name)").observe(.value, with: { (snapshot) in
            
            var newRecipes : [Recipe] = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let recipeDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let recipe = Recipe(key: key, dictionary: recipeDict)
                        print(recipe.id)
                        
                        
                        if (UserDefaults.standard.data(forKey: recipe.id) == nil) {
                            let yummlyAppId = UserDefaults.standard.string(forKey: "yummlyAppId") ?? "missingAppId"
                            let yummlyAppKey = UserDefaults.standard.string(forKey: "yummlyAppKey") ?? "missingAppKey"
                            var requestURL = "http://api.yummly.com/v1/api/recipe/" + recipe.id
                            requestURL = requestURL + "?_app_id=" + yummlyAppId + "&_app_key=" + yummlyAppKey
                            
                            Alamofire.request(requestURL).responseString{ response in
                                if (response.result.value) != nil {
                                    let stringResult = response.result.value
                                    UserDefaults.standard.set(stringResult, forKey: recipe.id)
                                    
                                    // prevents bad data from yummly getting shown to User and exception thrown!
                                    var storedForCheck = JSON.parse(stringResult!)
                                    let longIngredients = storedForCheck["ingredientLines"].arrayValue
                                    print("recipe ingred count is \(recipe.ingredients.count)")
                                    print("long ingred count is \(longIngredients.count)")
                                    
                                    if (recipe.ingredients.count == longIngredients.count) {
                                        newRecipes.append(recipe)
                                        self.recipes = newRecipes
                                        self.recipesTableView.reloadData()
                                    }
                                    
                                    
                                    
                                    UserDefaults.standard.synchronize()
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                }
                
                self.recipesTableView.reloadData()
                self.recipes = newRecipes
                
                print(newRecipes)
                
                
                
                
                
                
            }
            
            
        }) { (error) in
            
            print("this is error" + error.localizedDescription)
        }
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showRecipeDetail" {
            if let cell = sender as? UITableViewCell {
                let i = recipesTableView.indexPath(for: cell)!.row
                let vc = segue.destination as! RecipeDetailViewController
                print("the current recipe to transfer is !!")
                print(self.recipes[i])
                vc.currentRecipe = self.recipes[i]
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
