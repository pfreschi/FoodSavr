//  Item.swift
//  oweUone
//
//  Created by Peter Freschi on 4/1/17.
//
import UIKit
import Firebase
import FirebaseDatabase


extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy mm dd"
        return dateFormatter.string(from: self)
    }
}

class Item: NSObject {
    private var _itemRef: FIRDatabaseReference!
    
    private var _key: String!
    private var _name: String!
    private var _pic: String!
    private var _deleted: Bool!
    private var _disposed: Bool!
    private var _expirationDate: Int!
    private var _dateAdded: String!
    private var _creatorId: String!
    //group ID
    private var _groups: Dictionary<String,AnyObject>!
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
    
    var expirationDate: Int {
        get {
            return _expirationDate
        }
        
        set(newDate) {
            _expirationDate = newDate
        }
        
    }
    
    var dateAdded: String {
        return _dateAdded
    }
    
    var creatorId: String {
        return _creatorId
    }
    
    var groups: Dictionary<String,AnyObject> {
        return _groups
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
        
        if let newExpirationDate = dictionary["expirationDate"] as? Int {
            self._expirationDate = newExpirationDate
        }
        
        if let newDateAdded = dictionary["dateAdded"] as? String {
            self._dateAdded = newDateAdded
        }
        
        if let newCreatorId = dictionary["creatorId"] as? String {
            self._creatorId = newCreatorId
        }
        
        if let groups = dictionary["groups"] as? Dictionary<String,AnyObject> {
            self._groups = groups
        }
        
        //the above properties added to their key?!
        self._itemRef = FirebaseProxy.firebaseProxy.itemRef.child((String(self._key)))
        
    }
    
}
