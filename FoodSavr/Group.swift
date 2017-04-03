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
    
    private var _key: Int!
    private var _name: String!
    private var _deleted: Bool!
    private var _dateAdded: String!
    private var _creatorId: Int!
    private var _users: Array<User>!
    
    var groupRef: FIRDatabaseReference {
        return _groupRef
    }
    
    var key: Int {
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
    
    var creatorId: Int {
        return _creatorId
    }
    
    var users: Array<User> {
        return _users
    }
    
    init(key: Int, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        
        if let newName = dictionary["name"] as? String {
            self._name = newName
        }
        
        if let newDeleted = dictionary["deleted"] as? Bool {
            self._deleted = newDeleted
        }
        
        if let newDateAdded = dictionary["datedAdded"] as? String {
            self._dateAdded = newDateAdded
        }
        
        if let newCreatorId = dictionary["creatorId"] as? Int {
            self._creatorId = newCreatorId
        }
        
        if let newUsers = dictionary["users"] as? Array<User> {
            self._users = newUsers
        }
        
        //the above properties added to their key?!
        self._groupRef = FirebaseProxy.firebaseProxy.groupRef.child(String(self._key))
        
    }
    
    
    
}
