//
//  Group.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/2/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class Group: NSObject {
    private var _groupRef: FIRDatabaseReference!
    private var _key: String!
    private var _name: String!
    private var _deleted: Bool!
    private var _dateAdded: String!
    private var _creatorId: String!
    private var _users: Dictionary<String,Any>!
    private var _id: String!
    
    var groupRef: FIRDatabaseReference {
        return _groupRef
    }
    
    var key: String {
        return _key
    }
    
    var name: String {
        return _name
    }
    
    var deleted: Bool {
        return _deleted
    }
    
    var dateAdded: String {
        return _dateAdded
    }
    
    var creatorId: String {
        return _creatorId
    }
    
    var users: Dictionary<String,Any>!{
        return _users
    }
    var id : String {
        return _id
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        
        if let newName = dictionary["name"] as? String {
            self._name = newName
        }
        
        if let newDeleted = dictionary["deleted"] as? Bool {
            self._deleted = newDeleted
        }
        
        if let newDateAdded = dictionary["dateAdded"] as? String {
            self._dateAdded = newDateAdded
        }
        
        if let newCreatorId = dictionary["creatorId"] as? String {
            self._creatorId = newCreatorId
        }
        
        if let newUsers = dictionary["users"] as? Dictionary<String,Any>! {
            self._users = newUsers
        }
        if let newID = dictionary["id"] as? String {
            self._id = newID
        }
        
        //the above properties added to their key?!
        self._groupRef = FirebaseProxy.firebaseProxy.groupRef.child(String(self._key))
        
    }
    
    
    
}
