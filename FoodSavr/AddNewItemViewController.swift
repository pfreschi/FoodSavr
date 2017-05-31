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

class AddNewItemViewController: UIViewController {
   // var ingredients : NSArray

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var expirationDate: UITextField!

    
    @IBOutlet weak var warningText: UILabel!
    @IBAction func addItem(_ sender: Any) {
        let nameText = itemName.text
        let expText = expirationDate.text
        if (nameText!.isEmpty || expText!.isEmpty) {
            warningText.text = "Please fill out all the information!"
        } else {
            print("about to save!!")
            
            FirebaseProxy.firebaseProxy.saveItem(expDate: Int(expText!)!, name: nameText!)
            performSegue(withIdentifier: "itemAdded", sender: sender)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getIngredients()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


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
    
    
    func getIngredients() {
        //let ingredients = ["desctiption" = "", "searchValue" = "", "term" = ""]
        FirebaseProxy.firebaseProxy.myRootRef.child("ingredients").queryOrdered(byChild: "term").observeSingleEvent(of: .value, with: {(snapshot) in
            let result = snapshot.value 
//            if (result == nil){
//                print("result not found")
//               // var suggestion = Levenshtein.suggest(result, list: , ratio: 0.7, ignoreType: .all)
//            } else {
//                print("result found")
//            }
         print(result)
        })

    }
    
}
