//
//  GroupViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 5/17/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var group = Group(key:"none", dictionary: Dictionary<String, AnyObject>())

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var createdAt: UILabel!
    @IBAction func editButton(_ sender: Any) {
        groupName.isUserInteractionEnabled = true
        groupName.becomeFirstResponder()
        
    }
    @IBOutlet weak var groupTableview: UITableView!
    var userRef : FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = FirebaseProxy.firebaseProxy.userRef
        loadGroupData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroupData() {
        groupName.text = group.name
        self.title = group.name
        let dateStr = FirebaseProxy.firebaseProxy.convertToDate(dateString: group.dateAdded)
        createdAt.text = "Created on \(dateStr)"
        groupTableview.delegate = self
        groupTableview.dataSource = self
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return group.users.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KitchenItemsTableViewCell
        
//            cell.itemName.text = self.itemList[indexPath.row].name
//            setWhoAddedItem(cell: cell, indexPath: indexPath)
//            cell.expiration.text = expDate(days: self.itemList[indexPath.row].expirationDate)
//            
//            //TODO: ask about how to store images
//            cell.itemPic.sd_setImage(with: URL(string: self.itemList[indexPath.row].pic), placeholderImage: UIImage(named: "genericinventoryitem"))
        return cell
    }
    
//    func fetchMembers() {
//        for i in group.users.count {
//            userRef?.observe(.value, with: {(snapshot) in
//                var userlist : [User] = []
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshots {
//                        if let userDict = snap.value as? Dictionary<String, AnyObject> {
//                            let key = snap.key
//                            let user = User(key: key, dictionary: userDict)
//                            // don't show the current user him/herself
//                            if key != FirebaseProxy.firebaseProxy.getCurrentUser() {
//                                userlist.append(user)
//                            }
//                        }
//                    }
//                    self.users = userlist
//                    self.memTableView.reloadData()
//                }
//                
//            }) {(error) in
//                print("this is error" + error.localizedDescription)
//                
//            }
//        }
//        
//    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
