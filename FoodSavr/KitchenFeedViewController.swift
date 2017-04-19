//
//  KitchenFeedViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class KitchenFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref : FIRDatabaseReference?
    var itemList:[Item] = []
    
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        ref = FirebaseProxy.firebaseProxy.myRootRef
        print(ref)
        
        ref?.child("items").observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshots)
                for snap in snapshots {
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(key: key, dictionary: itemDict)
                        //self.itemList.insert(item, at: 0)
                        self.itemList.append(item)
                        print("this is key" + item.name)
                        
                    }
                }
            }
            
            self.table.reloadData()
        }) { (error) in
            print("there is error")
            
            print("this is error" + error.localizedDescription)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("this is count: \(itemList.count)")
        return itemList.count
    }
    
    func setupUI() {
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hi")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KitchenItemsTableViewCell
        cell.itemName.text = self.itemList[indexPath.row].name
        //TODO: convert to name!
        //cell.addedby.text = self.itemList[indexPath.row].creatorId
        cell.expiration.text = self.itemList[indexPath.row].expirationDate
        
        //TODO: ask about how to store images
        //cell.itemPic.image.
        
        
        return cell
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(true)
    //        if let row = table.indexPathForSelectedRow {
    //            self.table.deselectRow(at: row, animated: false)
    //        }
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
