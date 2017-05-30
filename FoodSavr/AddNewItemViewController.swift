//
//  AddNewItemViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/30/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class AddNewItemViewController: UIViewController {

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var expirationDate: UITextField!

    
    @IBOutlet weak var warningText: UILabel!
    @IBAction func addItem(_ sender: Any) {
        let nameText = itemName.text
        let expText = expirationDate.text
        if (nameText!.isEmpty || expText!.isEmpty) {
            warningText.text = "Please fill out all the information!"
        } else {
            addNewItem()
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewItem() {
        let creatorId = FirebaseProxy.firebaseProxy.getCurrentUser()
        let currentDate = String(describing: Date())
        print(currentDate)
        
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
