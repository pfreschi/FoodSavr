//
//  Recipe.swift
//  FoodSavr
//
//  Created by Peter Freschi on 5/21/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import FirebaseDatabase


class Recipe: NSObject {
    private var _recipeRef: FIRDatabaseReference!
    
    private var _key: String!
    private var _id: String!
    private var _ingredients: Array<String>!
    private var _recipeName: String!
    private var _smallImageUrls: Array<String>!
    private var _attributes: NSDictionary!
    private var _flavors: NSDictionary!
    private var _rating: String!
    
    
    var key: String {
        return _key
    }
    var recipeRef: FIRDatabaseReference {
        return _recipeRef
    }
    
    var id: String {
        return _id
    }
    
    var recipeName: String {
        return _recipeName
    }
    
    var ingredients: Array<String> {
        return _ingredients
    }
    
    var smallImageUrls: Array<String> {
        return _smallImageUrls
    }
    
    var attributes: NSDictionary {
        return _attributes
    }
    
    var flavors: NSDictionary {
        return _flavors
    }
    
    var rating: String {
        return _rating
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        // yummly ID for getrecipe call
        if let newId = dictionary["id"] as? String {
            self._id = newId
        }
        if let newRecipeName = dictionary["recipeName"] as? String {
            self._recipeName = newRecipeName
        }
        if let newIngredients = dictionary["ingredients"] as? Array<String> {
            self._ingredients = newIngredients
        }
        if let newSmallImageUrls = dictionary["smallImageUrls"] as? Array<String> {
            self._smallImageUrls = newSmallImageUrls
        }
        if let newAttributes = dictionary["attributes"] as? NSDictionary {
            self._attributes = newAttributes
        }
        if let newFlavors = dictionary["flavors"] as? NSDictionary {
            self._flavors = newFlavors
        }

        if let newRating = dictionary["rating"] as? String {
            self._rating = newRating
        }
    
        self._recipeRef = FirebaseProxy.firebaseProxy.recipeRef.child((String(self._key)))
        
        
    }
    
}
