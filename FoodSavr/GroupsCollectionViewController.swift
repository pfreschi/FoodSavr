//
//  CollectionViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/10/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "groupCell"

class GroupsCollectionViewController: UICollectionViewController {
    var groupRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    var userGroupsRef : FIRDatabaseReference!
    var groups : [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        groupRef = FirebaseProxy.firebaseProxy.groupRef
        userRef = FirebaseProxy.firebaseProxy.userRef
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        fetchGroups()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 0, right: 2)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchGroups() {
        var newGroups :[Group] = []
        userGroupsRef.child(FirebaseProxy.firebaseProxy.getCurrentUser()).observe(.childAdded , with: {(snapshot) in
                //self.groups.append(snapshot)
        if let groupDict = snapshot.value as? Dictionary<String, AnyObject>{
            print("hello")
            print(groupDict)
            let key = snapshot.key
            let g = Group(key: key, dictionary: groupDict)
            newGroups.append(g)
        }

        self.groups = newGroups
        self.collectionView!.reloadData()
        

        })
//        userRef.queryOrdered(byChild: "groups").observe(.value, with: {(snapshot) in
//        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//            for snap in snapshots {
//                self.groupRef.child(snap.key).observeSingleEvent(of: .value, with: { (s) in
//                    print(s)
//                    if let groupDict = s.value as? Dictionary<String, AnyObject> {
//                        let k = s.key
//                        let g = Group(key: k, dictionary: groupDict)
//                        newGroups.append(g)
//                        print(g)
//                        
//                    }
//                })
//                
//            }
//            self.groups = newGroups
//        }
        
        //})
        
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.groups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GroupCollectionViewCell
        //cell.backgroundColor = UIColor.black
        // Configure the cell
        cell.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor
        cell.groupName.layer.backgroundColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2
        cell.groupName.text = self.groups[indexPath.row].name
        
        
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
