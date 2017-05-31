//
//  User.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/1/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class User: NSObject {
    private var _UserRef: FIRDatabaseReference!
    
    private var _key: String
    private var _email: String!
    private var _name: String!
    private var _age: Int!
    private var _zipCode: Int!

    private var _phone: Int!
    private var _diet: Array<String>!
    private var _restrictedIngredients: Array<String>!
    private var _receipts: Array<String>!
    
    private var _groups: Dictionary<String, Bool>!
    private var _pic: String!
    private var _itemIDs: Array<String>!
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
    
    var diet: Array<String> {
        return _diet
        
    }
    
    var restrictedIngredients: Array<String> {
        return _restrictedIngredients
    }
    
    var receipts: Array<String> {
        return _receipts
    }
    
    var groups: Dictionary<String, Bool> {
        return _groups
    }
    
    var pic: String {
        return _pic
    }
    var itemIDs: Array<String> {
        return _itemIDs
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
        
        if let newDiet = dictionary["diet"] as? Array<String> {
            self._diet = newDiet
        }
        
        if let newRestrictedIngredients = dictionary["restrictedIngredients"] as? Array<String> {
            self._restrictedIngredients = newRestrictedIngredients
        }
        if let newReceipts = dictionary["receipts"] as? Array<String> {
            self._receipts = newReceipts
        }
        if let newGroups = dictionary["groups"] as? Dictionary<String, Bool> {
            self._groups = newGroups
        }
        if let newPic = dictionary["pic"] as? String {
            self._pic = newPic
        }
        
        if let newItemIDs = dictionary["itemIDs"] as? Array<String> {
            self._itemIDs = newItemIDs
        }
        
        //the above properties added to their key?!
        self._UserRef = FirebaseProxy.firebaseProxy.myRootRef.child("users").child(self._key)
        
    }
}
