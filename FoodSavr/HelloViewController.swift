//
//  HelloViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/8/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import M13Checkbox


class HelloViewController: UIViewController, UITextFieldDelegate {
    
    var dietPreferences = [String: Bool]()
    var allergyPreferences = [String: Bool]()
    
    var dietOptions = ["Lacto vegetarian", "Ovo vegetarian", "Vegan", "Pescetarian"]
    var allergyOptions = ["Dairy", "Peanut", "Soy", "Tree Nut", "Egg", "Seafood", "Sulfite", "Gluten", "Sesame", "Wheat"]
    

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var welcomeOrEndView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var dietView: UIView!
    @IBOutlet weak var allergyView: UIView!
    @IBOutlet weak var preferenceView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var welcomeOrEndText: UILabel!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionDietOrAllergyText: UILabel!
    @IBOutlet weak var welcomeOrEndContinue: BorderedButton!
    @IBOutlet weak var welcomeOrEndSkip: BorderedButton!
    @IBOutlet weak var preferenceTextBox: UITextField!
    @IBOutlet weak var outerContinueButton: BorderedButton!
    
    var currentStep = 0 //Diet is 1, Allergy is 2, Preference is 3
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func editingPrefEnded(_ sender: UITextField, forEvent event: UIEvent) {
        FirebaseProxy.firebaseProxy.myRootRef.child("ingredients").queryOrdered(byChild: "term").queryEqual(toValue: sender.text).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let result = snapshot.value as? NSDictionary
            if (result == nil){
                self.outerContinueButton.isEnabled = false
                print("result not found")
            } else {
                self.outerContinueButton.isEnabled = true
                print("result found")
            }
            
            //let term = value?["term"] as? String ?? "none"
            //print(term)
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }
    @IBOutlet var dietCheckboxes: [M13Checkbox]!
    @IBOutlet var allergyCheckboxes: [M13Checkbox]!

    @IBAction func checkboxPressed(_ sender: M13Checkbox, forEvent event: UIEvent) {

        if (currentStep == 1){
            let nameOfOption = dietOptions[sender.tag]
            if (sender.checkState == M13Checkbox.CheckState.checked){
                dietPreferences[nameOfOption] = true
                print(nameOfOption + " was checked!")
            } else if (sender.checkState == M13Checkbox.CheckState.unchecked){
                // remove it from the dictionary by setting to nil
                dietPreferences[nameOfOption] = nil
                print(nameOfOption + " was unchecked!")
            } else {
                print("cannot read checkbox change")
            }
        } else if (currentStep == 2){
            let nameOfOption = allergyOptions[sender.tag]
            if (sender.checkState == M13Checkbox.CheckState.checked){
                allergyPreferences[nameOfOption] = true
                print(nameOfOption + " was checked!")
            } else if (sender.checkState == M13Checkbox.CheckState.unchecked){
                // remove it from the dictionary by setting to nil
                allergyPreferences[nameOfOption] = nil
                print(nameOfOption + " was unchecked!")
            } else {
                print("cannot read checkbox change")
            }

        }
        
    }
    
    @IBAction func skipFromWelcome(_ sender: BorderedButton, forEvent event: UIEvent) {
            // segue to main app area
            let nextView = (self.storyboard?.instantiateViewController(withIdentifier: "tabBar"))! as UIViewController
            self.present(nextView, animated: true, completion: nil)


    }
    
    @IBAction func continueFromWelcomeOrEnd(_ sender: UIButton) {
        if (currentStep == 0){ // at welcome screen
            welcomeOrEndView.isHidden = true
            outerView.isHidden = false
            dietView.isHidden = false
            initializeCheckboxes(checkboxesArray: dietCheckboxes)
            currentStep += 1
            titleText.text = "Diet"
            descriptionDietOrAllergyText.text = "Please tell us about your diet."
        } else if (currentStep == 4){ // at end get started
            // TODO: segue to next screen!!
            let nextView = (self.storyboard?.instantiateViewController(withIdentifier: "tabBar"))! as UIViewController
            self.present(nextView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func skipToNextStep(_ sender: BorderedButton, forEvent event: UIEvent) {
        self.currentStep += 1
        print("new step is \(currentStep)")
        
        if (currentStep >= 3) { //pref check

            self.outerView.isHidden = true
            self.welcomeOrEndView.isHidden = false
            self.welcomeOrEndText.text = "Thank you very much for \n telling us about you. We hope you enjoy FoodSavr!"
            self.welcomeOrEndContinue.setTitle("Get Started", for: .normal)
            self.welcomeOrEndSkip.isHidden = true
            savePrefs()
            

        } else {
            if (currentStep == 1){ //on diet page
                dietView.isHidden = true
                allergyView.isHidden = false
                initializeCheckboxes(checkboxesArray: allergyCheckboxes)
                titleText.text = "Allergy"
                descriptionDietOrAllergyText.text = "Please tell us about your \n food allergies."
                
            } else if (currentStep == 2){ //on allergy page
                allergyView.isHidden = true
                preferenceView.isHidden = false
                titleText.text = "Preference"
                descriptionDietOrAllergyText.isHidden = true
            }
            

        }
    }
    
    
    @IBAction func continueToNextStep(_ sender: UIButton, forEvent event: UIEvent) {
        if (currentStep >= 3) { //pref check
            FirebaseProxy.firebaseProxy.myRootRef.child("ingredients").queryOrdered(byChild: "term").queryEqual(toValue: preferenceTextBox.text).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let result = snapshot.value as? NSDictionary
                if (result == nil){
                    print("result not found")
                } else {
                    print("result found or none specified")
                    self.outerView.isHidden = true
                    self.welcomeOrEndView.isHidden = false
                    self.welcomeOrEndText.text = "Thank you very much for \n telling us about you. We hope you enjoy FoodSavr!"
                    self.welcomeOrEndContinue.setTitle("Get Started", for: .normal)
                    self.welcomeOrEndSkip.isHidden = true
                    self.currentStep += 1
                    self.savePrefs()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }

        } else {
            if (currentStep == 1){ //on diet page
                dietView.isHidden = true
                allergyView.isHidden = false
                initializeCheckboxes(checkboxesArray: allergyCheckboxes)
                titleText.text = "Allergy"
                descriptionDietOrAllergyText.text = "Please tell us about your \n food allergies."
                
            } else if (currentStep == 2){ //on allergy page
                allergyView.isHidden = true
                preferenceView.isHidden = false
                titleText.text = "Preference"
                descriptionDietOrAllergyText.isHidden = true
                
            }
            
            
            print(currentStep)
            currentStep += 1

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.preferenceTextBox.delegate = self;
        
        welcomeOrEndView.isHidden = false
    
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "quizbackground.png")
        self.mainView.insertSubview(backgroundImage, at: 0)
        
        setProfilePic()
        setName()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.profileImageView.layer.borderWidth = 5.0
        self.profileImageView.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor

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
            //let lastName = fullNameArr[1]
            self.welcomeOrEndText.text = "Hello, \(name).\n Welcome to FoodSavr!\n We would love to get to \n know you before you \n get started."
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initializeCheckboxes(checkboxesArray : [M13Checkbox]) {
        for checkbox in checkboxesArray {
            checkbox.setMarkType(markType: M13Checkbox.MarkType.radio, animated: true)
            checkbox.boxType = M13Checkbox.BoxType.square
            checkbox.tintColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0)
            checkbox.stateChangeAnimation = M13Checkbox.Animation.expand(.stroke)
        }
    }
    
    func savePrefs() {
        // save collected info to Firebase
        let currentUser = FIRAuth.auth()?.currentUser?.uid
        
        
        FirebaseProxy.firebaseProxy.userRef.child(currentUser!).child("diet").setValue(
            Array(self.dietPreferences.keys)
        )
        FirebaseProxy.firebaseProxy.userRef.child(currentUser!).child("allergy").setValue(
            Array(self.allergyPreferences.keys)
        )
        FirebaseProxy.firebaseProxy.userRef.child(currentUser!).child("excludedIngredients").setValue(
            self.preferenceTextBox.text
        )
        
        print("diets are \(self.dietPreferences.keys)")
        print("allergies are \(self.allergyPreferences.keys)")
        print("excluded is \(self.preferenceTextBox.text)")

    }

    
    
}

