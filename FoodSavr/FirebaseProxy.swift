//
//  FirebaseProxy.swift
//  FoodSavr
//  
//  This class provides methods that interact with the Firebase database.
//  Created by Peter Freschi on 4/2/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class FirebaseProxy: NSObject {
    
    static let firebaseProxy = FirebaseProxy()


    
    // Connect to Firebase DB
    private var _myRootRef = FIRDatabase.database().reference()
    private var _itemRef = FIRDatabase.database().reference().child("items")
    private var _receiptRef = FIRDatabase.database().reference().child("receipts")
    private var _userRef = FIRDatabase.database().reference().child("users")
    private var _groupRef = FIRDatabase.database().reference().child("groups")
    private var _userGroupsRef = FIRDatabase.database().reference().child("userGroups")
    

    
    
    var myRootRef: FIRDatabaseReference {
        return _myRootRef
    }
    var itemRef: FIRDatabaseReference {
        return _itemRef
    }
    var receiptRef: FIRDatabaseReference {
        return _receiptRef
    }
    var userRef: FIRDatabaseReference {
        return _userRef
    }
    var groupRef: FIRDatabaseReference {
        return _groupRef
    }
    var userGroupsRef: FIRDatabaseReference {
        return _userGroupsRef
    }
    
    
    /*
     private var _receiptRef: FIRDatabaseReference!
     
     private var _key: Int!
     private var _pic: UIImage!
     private var _deleted: Bool!
     private var _dateAdded: String!
     private var _creatorId: Int!
     private var _items: Array<String>! //array of item id
     private var _vendor: String!
     
     */
    
    func saveReceipt(pic: String, creatorId: String, items: [String], vendor: String) {
        
        let key = FirebaseProxy.firebaseProxy.receiptRef.childByAutoId().key
        let currentDate = String(describing: Date())
        
        let newReceiptDetails : [String:Any] = [
            "pic": pic,
            "deleted": false,
            "dateAdded": currentDate,
            "creatorId": creatorId,
            // TODO: fix this after text recognization pull in
            "items": items,
            // QUESTION: vendor of product or store?
            "vendor": vendor
        
        ]
        
        self.receiptRef.child(key).setValue(newReceiptDetails)
    }
    
    func saveGroup(name: String, creatorId: String, members: [String]){
        let key = groupRef.childByAutoId().key
        let currentDate = String(describing: Date())
        var userGroupsUpd : Dictionary<String, Any> = [:]
        //var users : Dictionary<String, Bool> = [:]

        
        // this is under groupRef
        let newGroup : [String:Any] = [
            "name": name,
            "deleted": false,
            "dateAdded" : currentDate,
            "creatorId": creatorId,
            "users": members
        ]
        
        for m in members {
            userGroupsUpd["/\(m)/\(key)"] = newGroup
        }
        
        //update group, update userGroups for each memeber!!!
        
        self.groupRef.child(key).updateChildValues(newGroup)
        self.userGroupsRef.updateChildValues(userGroupsUpd)
        
    }
    
    func getCurrentUser() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    /*
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            let imgURLString = "https://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOfURL: imgURL!)
            let image = UIImage(data: imageData!)
            return image
        }
        return nil
    }
    
    func convertStringDatetoNSDate(dateString : String) -> NSDate {
        let localeStr = "us"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeStr)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let date: NSDate? = dateFormatter.dateFromString(dateString)
        return date!
    }
    
    
    //fair use of function from jacks205 on GitHub
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "an hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "a minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "just now"
        }
    }
 */
    

}
