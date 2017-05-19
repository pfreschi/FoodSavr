//
//  ProfileViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 5/16/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FBSDKLoginKit


class ProfileViewController: UIViewController {
    
    var dietPreferences = [String: Bool]()
    var allergyPreferences = [String: Bool]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setProfilePic() {
        let userID = FBSDKAccessToken.current().userID
        
        print(userID!)
        
        let url = URL(string: "https://graph.facebook.com/\(userID!)/picture?type=large")!
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
        
    }
    
    func setName() {
        let userRef = FirebaseProxy.firebaseProxy.userRef
        let userID = FIRAuth.auth()?.currentUser?.uid
        userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user's name
            print("this is printing user name")
            let value = snapshot.value as? NSDictionary
            let fullName = value?["name"] as? String ?? "User"
            
            let fullNameArr = fullName.components(separatedBy: " ")
            
            let name    = fullNameArr[0]
            let lastName = fullNameArr[1]
            self.welcomeOrEndText.text = "Hello, \(name).\n Welcome to FoodSavr!\n We would love to get to \n know you before you \n get started."
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
}


