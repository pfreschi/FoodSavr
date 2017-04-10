//
//  Receipt.swift
//  FoodSavr
//
//  Created by Peter Freschi on 4/1/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class Receipt: NSObject {
    private var _receiptRef: FIRDatabaseReference!
    
    private var _key: Int!
    private var _pic: String!
    private var _deleted: Bool!
    private var _dateAdded: String!
    private var _creatorId: Int!
    private var _items: Array<String>! //array of item id
    private var _vendor: String!
    
    var receiptRef: FIRDatabaseReference {
        return _receiptRef
    }
    
    var key: Int {
        return _key
    }
    
    var pic: String {
        return _pic
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
    
    var items: Array<String> {
        return _items
    }
    
    var vendor: String {
        return _vendor
    }
    
    init(key: Int, dictionary: Dictionary<String, AnyObject>) {
        self._key = key
        if let newPic = dictionary["pic"] as? String {
            self._pic = newPic
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
        
        if let newItems = dictionary["items"] as? Array<String> {
            self._items = newItems
        }
        
        if let newVendor = dictionary["vendor"] as? String {
            self._vendor = newVendor
        }
        
        //the above properties added to their key?!
        self._receiptRef = FirebaseProxy.firebaseProxy.receiptRef.child(String(self._key))
        
    }
    
    
    
}

