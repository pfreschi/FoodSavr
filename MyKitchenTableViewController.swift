//
//  MyKitchenTableViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/18/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class MyKitchenViewController: UIViewController, UITableViewDelegate  {
    
    let rootRef = FirebaseProxy().myRootRef
    let itemRef = FirebaseProxy().itemRef
    
    
    var ref : FIRDatabaseReference?
    var itemList:[Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("is it loading??")
        
//        rootRef = FirebaseProxy().myRootRef
//        itemRef = FirebaseProxy().itemRef
        
        setupUI()
        ref = FIRDatabase.database().reference()
        
       
        ref?.child("items").observe(.childAdded, with: { (snapshot) in
           // self.itemList = []
            print(snapshot)
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(key: key, dictionary: itemDict)
                        self.itemList.insert(item, at: 0)
                        print(self.itemList.count)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
        })


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.itemList.count
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //fetch items from firebase and load it to tableview
    func getItems() {
          }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomProductCell
        cell.itemName.text = self.itemList[indexPath.row].name
        //TODO: convert to name!
        //cell.addedby.text = self.itemList[indexPath.row].creatorId
        cell.expirtaion.text = self.itemList[indexPath.row].expirationDate
        
        //TODO: ask about how to store images
        //cell.itemPic.image.
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
