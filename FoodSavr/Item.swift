//
//  Item.swift
//  oweUone
//
//  Created by Peter Freschi on 4/1/17.
//

import UIKit
import Firebase
import FirebaseDatabase

class Item: NSObject {
    private var _itemRef: FIRDatabaseReference!
    
    private var _key: String!
    private var _name: String!
    private var _pic: String!
    private var _deleted: Bool!
    private var _disposed: Bool!
    private var _expirationDate: String!
    private var _dateAdded: String!
    private var _creatorId: Int!
    //group ID
    private var _sharedWith: String!
    //private var _ingredients: Array<String>!
    //private var _category: String!
    
    
    var itemRef: FIRDatabaseReference {
        return _itemRef
    }
    
    var key: String {
        return _key
    }
    
    var name: String {
        return _name
    }
    
    var pic: String {
        return _pic
    }
    
    var deleted: Bool {
        return _deleted
    }
    
    var disposed: Bool {
        return _disposed
    }
    
    var expirationDate: String {
        return _expirationDate
    }
    
    var dateAdded: String {
        return _dateAdded
    }
    
    var creatorId: Int {
        return _creatorId
    }
    
    var sharedWith: String {
        return _sharedWith
    }
    
//    var ingredients: Array<String> {
//        return _ingredients
//    }
//    
//    var category: String {
//        return _category
//    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        if let newName = dictionary["name"] as? String {
            self._name = newName
        }
        
        if let newPic = dictionary["pic"] as? String {
            self._pic = newPic
        }
        
        if let newDeleted = dictionary["deleted"] as? Bool {
            self._deleted = newDeleted
        }
        
        if let newDisposed = dictionary["disposed"] as? Bool {
            self._disposed = newDisposed
        }
        
        if let newExpirationDate = dictionary["expirationDate"] as? String {
            self._expirationDate = newExpirationDate
        }
        
        if let newDateAdded = dictionary["datedAdded"] as? String {
            self._dateAdded = newDateAdded
        }
        
        if let newCreatorId = dictionary["creatorId"] as? Int {
            self._creatorId = newCreatorId
        }
        
        if let newSharedWith = dictionary["sharedWith"] as? String {
            self._sharedWith = newSharedWith
        }
        
//        if let newIngredients = dictionary["ingredients"] as? Array<String> {
//            self._ingredients = newIngredients
//        }
//        
//        if let newCategory = dictionary["category"] as? String {
//            self._category = newCategory
//        }
        
        //the above properties added to their key?!
        self._itemRef = FirebaseProxy.firebaseProxy.itemRef.child((String(self._key)))
        
    }
    
    
    
}
