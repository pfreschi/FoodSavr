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

        groupRef = FirebaseProxy.firebaseProxy.groupRef
        userRef = FirebaseProxy.firebaseProxy.userRef
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        fetchGroups()
        
        let padding: CGFloat = 30
        let collectionCellSize = collectionView!.frame.size.width - padding
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 3, bottom: 25, right: 3)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        collectionView!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchGroups() {
        var newGroups :[Group] = []
        userGroupsRef.child(FirebaseProxy.firebaseProxy.getCurrentUser()).observe(.childAdded , with: {(snapshot) in
        if let groupDict = snapshot.value as? Dictionary<String, AnyObject>{
            let key = snapshot.key
            let g = Group(key: key, dictionary: groupDict)
            newGroups.append(g)
        }

        self.groups = newGroups
        self.collectionView!.reloadData()
        })
        
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
        cell.layer.borderWidth = 1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showAgroup" {
            if let cell = sender as? UICollectionViewCell {
                let i = self.collectionView!.indexPath(for: cell)!.row
                let vc = segue.destination as! GroupViewController
                vc.group = self.groups[i]
                vc.groupKey = self.groups[i].key
            }
        }
    }
}
