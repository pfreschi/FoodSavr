//
//  User.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/1/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    private var _UserRef: FIRDatabaseReference!
    
    private var _key: String
    private var _email: String!
    private var _name: String!
    private var _age: Int!
    private var _zipCode: Int!

    private var _phone: Int!
    private var _dietaryRestrictions: Array!
    private var _restrictedIngredients: Array!
    
    private var _groups: Array!
    private var _pic: UIImage!
    
    var key: String {
        return _key
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }

    var age: Int {
        return _age
    }
    
    var zipCode: Int {
        return _zipCode
    }
    
    var phone: Int {
        return _phone
    }
    
    var dietaryRestrictions: Array {
        return _dietaryRestrictions
    }
    
    var restrictedIngredients: Array {
        return _restrictedIngredients
    }
    
    var groups: Array {
        return _groups
    }
    
    var pic: UIImage {
        return _pic
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        if let newEmail = dictionary["email"] as? String {
            self._email = newEmail
        }
        
        if let newName = dictionary["name"] as? String {
            self._name = newName
        }
        
        if let newAge = dictionary["age"] as? Int {
            self._age = newAge
        }
        
        if let newZipCode = dictionary["zipCode"] as? Int {
            self._zipCode = newZipCode
        }

        if let newPhone = dictionary["phone"] as? Int {
            self._phone = newPhone
        }
        
        if let newDietaryRestrictions = dictionary["dietaryRestrictions"] as? Array {
            self._dietaryRestrictions = newDietaryRestrictions
        }
        
        if let newRestrictedIngredients = dictionary["restrictedIngredients"] as? Array {
            self._restrictedIngredients = newRestrictedIngredients
        }
        if let newGroups = dictionary["groups"] as? Array {
            self._groups = newGroups
        }
        
        if let newPic = dictionary["pic"] as? UIImage {
            self._pic = newPic
        }
        
        //the above properties added to their key?!
        self._UserRef = FirebaseProxy.firebaseProxy.myRootRef.child("users").child(self._key)
        
    }
    
    
    
}
