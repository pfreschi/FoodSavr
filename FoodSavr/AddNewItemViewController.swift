//
//  AddNewItemViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/30/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import Levenshtein
import SwiftOverlays

class AddNewItemViewController: UIViewController {
    var ingredients : [String] = []

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var expirationDate: UITextField!

    
    @IBOutlet weak var warningText: UILabel!
    @IBAction func addItem(_ sender: Any) {
        let nameText = itemName.text
        let expText = expirationDate.text
        
        if (nameText!.isEmpty || expText!.isEmpty) {
            warningText.text = "Please fill out all the information!"
        } else {
//            
//            let suggestion = checkItemname(name: nameText!)
//            print(suggestion)
//            if !suggestion.isEmpty {
            
                //itemName.text = suggestion
                FirebaseProxy.firebaseProxy.saveItem(expDate: Int(expText!)!, name: nameText!)
                performSegue(withIdentifier: "itemAdded", sender: sender)
            //}
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // ingredients = UserDefaults.standard.array(forKey: "ingredients") as! [String]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func checkItemname (name: String) -> String {
//        
//        let suggestion = Levenshtein.suggest(name, list: ingredients, ratio: 0.7, ignoreType: .all)
//        //print(suggestion)
//        if (suggestion != nil) {
//            return suggestion!
//            
//        }
//        return ""
//        
//    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "itemAdded" {
            if let destVC = segue.destination as? KitchenFeedViewController {
                destVC.itemAdded = true
            }
        }
    }
    
    
}
