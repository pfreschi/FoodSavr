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
import FirebaseAuth
import FBSDKLoginKit


class ProfileViewController: UIViewController {
    
    var dietPreferences = [String: Bool]()
    var allergyPreferences = [String: Bool]()

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dietaryText: UILabel!
    @IBOutlet weak var allergyText: UILabel!
    @IBOutlet weak var dislikeText: UILabel!
    
    @IBAction func logOut(_ sender: Any) {
        

        UserDefaults.standard.set(nil, forKey: "uid")
        
        let FBManager = FBSDKLoginManager()
        FBManager.logOut()
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        // segue back to login view
        let nextView = (self.storyboard?.instantiateViewController(withIdentifier: "login"))! as UIViewController
        self.present(nextView, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        setNameAndPrefs()

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
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 5.0
        self.profileImageView.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor
        
    }
    
    func setNameAndPrefs() {
        let userRef = FirebaseProxy.firebaseProxy.userRef
        let userID = FIRAuth.auth()?.currentUser?.uid
        userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user's name
            let value = snapshot.value as? NSDictionary
            let fullName = value?["name"] as? String ?? "User"
            self.name.text = fullName
            
            let email = value?["email"] as? String ?? "Email"
            self.email.text = email
            
            let diet = value?["diet"] as? NSArray ?? NSArray()
            print(diet)
            self.dietaryText.text = "Dietary: "
            if diet.count != 0 {
                for (index, elem) in diet.enumerated() {
                    if index != diet.count - 1 {
                        self.dietaryText.text?.append("\(elem), ")
                    } else {
                        self.dietaryText.text?.append("\(elem) ")
                    }
                    
                }
            } else {
                self.dietaryText.text?.append("N/A")
            }
            let allergy = value?["allergy"] as? NSArray ?? NSArray()
            self.allergyText.text = "Allergies: "
            if allergy.count != 0 {
                for (index, elem) in allergy.enumerated() {
                    if index != allergy.count - 1 {
                        self.allergyText.text?.append("\(elem), ")
                    } else {
                        self.allergyText.text?.append("\(elem) ")
                    }
                    
                }
            } else {
                self.allergyText.text?.append("N/A")
            }
            let excludedIngredient = value?["excludedIngredients"] as? String ?? "N/A"
            self.dislikeText.text = "Dislikes: "
            
            if excludedIngredient != "" {
                self.dislikeText.text?.append(excludedIngredient.capitalized)
            } else {
                self.dislikeText.text?.append("N/A")
            }
            

        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
}


