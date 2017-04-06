//
//  AuthenticationViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/5/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit



class AuthenticationViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    var rootRef : FIRDatabaseReference! = nil
    var userRef : FIRDatabaseReference! = nil
    var newUserInfo : [String: Any] = [   "email": "",
                                          "name": "",
                                          "age": 0,
                                          "zipCode": 0,
                                          "phone": 0,
                                          "dietaryRestrictions": [String](),
                                          "restrictedIngredients": [String](),
                                          "groups": [String](),
                                          "pic": "",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        rootRef = FIRDatabase.database().reference()
        userRef = FirebaseProxy.firebaseProxy.userRef


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        self.firebaseLogin(credential: credential)

        
        print("Successfully logged in with facebook...")
    }
    
    func firebaseLogin(credential: FIRAuthCredential) {
        if FIRAuth.auth()?.currentUser?.link != nil{
            print("Current user has been linked with a firebase credential.")
            afterSuccessfulFBLogin(userUid: (FIRAuth.auth()?.currentUser?.uid)!)
        } else {
            
            //start a new firebase credential
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    
                    // add the new user to Firebase database
                    for profile in user!.providerData {
                        let userUid = profile.uid
                        self.newUserInfo["name"] = profile.displayName!
                        self.newUserInfo["email"] = profile.email!
                        self.newUserInfo["pic"] = profile.photoURL?.absoluteString
                        
                        UserDefaults.standard.setValue(userUid, forKey: "uid")
                        self.afterSuccessfulFBLogin(userUid: userUid)
                        
                    }
                }
            }
        }
    }
    
    func afterSuccessfulFBLogin(userUid : String) {
        self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // if user had logged in before and has items in their kitchen, go to Kitchen
            if snapshot.hasChild(userUid) && snapshot.childSnapshot(forPath: userUid).childSnapshot(forPath: "receipts").childrenCount > 0  {
                // TODO: REPLACE IDENTIFIER BELOW WITH CORRECT KITCHEN VIEWCONTROLLER
                print("going to Kitchen View")
                //self.showViewWithIdentifier(identifier: "tabBar")
                
            } else if snapshot.hasChild(userUid){ // user logged in before but has NO items in kitchen, take to Receipt Add View
                // TODO: REPLACE IDENTIFIER BELOW WITH CORRECT RECEIPT VIEWCONTROLLER
                print("going to Receipt View")
                //self.showViewWithIdentifier(identifier: "AddReceipt")
                
            } else { // new user
                print("adding new user")
                self.addNewUser(userUid: userUid)
                //self.showViewWithIdentifier(identifier: "AddReceipt")
            }
        })

    }
    
    /*
    // get user's info with facebook token
    func getProfilePic() -> UIImage{
        if FBSDKAccessToken.current() != nil {
     
            let userID = FBSDKAccessToken.current().userID
     
            if(userID != nil) //should be != nil
            {
                print(userID!)
            }
            
            let URL = NSURL(string: "http://graph.facebook.com/\(String(describing: userID))/picture?type=large")!
        
            return UIImage(data: URL)!
            
        } else{
            
        }
    }
 */
    
    func showViewWithIdentifier(identifier: String) {
        let nextView = (self.storyboard?.instantiateViewController(withIdentifier: identifier))! as UIViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    
    // Enable if we want to collect addtl information like Phone Number.
    /*
    func getAdditionalUserInfo(userUid: String) {
        let alertController = UIAlertController.init(title: "Login Successful", message: "Please enter your phone number", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title:"Submit", style:.default, handler: {
            alert -> Void in

            self.newUserInfo["phone"] = alertController.textFields![0].text!
            
            self.addNewUser(userUid: userUid)
            self.showViewWithIdentifier(identifier: "AddReceipt")
            self.setNeedsFocusUpdate()
        })
        
        alertController.addAction(updateAction)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "000-000-0000"
        }
        
        alertController.view.setNeedsLayout()
        self.present(alertController, animated: true, completion: nil)
    }
 */
    
    // add new user into firebase
    
    func addNewUser(userUid: String) {
        self.rootRef.child("users").child(userUid).setValue(self.newUserInfo)
    }

 
    
}

