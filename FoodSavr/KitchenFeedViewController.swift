//
//  KitchenFeedViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import SDWebImage


class KitchenFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UISearchBarDelegate{
    
    var ref : FIRDatabaseReference?
    var itemRef: FIRDatabaseReference?
    var itemList:[Item] = []
    var filteredItemList:[Item] = []
    var curUser : FIRUser?
    var imagePicker: UIImagePickerController!
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ref = FirebaseProxy.firebaseProxy.myRootRef
        itemRef = FirebaseProxy.firebaseProxy.itemRef
        curUser = (FIRAuth.auth()?.currentUser)!
        
        itemRef?.queryOrdered(byChild: "expirationDate").observe(.value, with: { (snapshot) in
            
            var newItems : [Item] = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshots)
                for snap in snapshots {
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(key: key, dictionary: itemDict)
                        //self.itemList.insert(item, at: 0)
                        newItems.append(item)
                        print("this is key" + item.name + item.key)
                        
                    }
                }
                self.itemList = newItems
                self.table.reloadData()
                
            }
            
            
        }) { (error) in
            
            print("this is error" + error.localizedDescription)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredItemList.count
        }

        return itemList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setupUI() {
        table.delegate = self
        table.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KitchenItemsTableViewCell
        
        if isSearching {
            cell.itemName.text = self.filteredItemList[indexPath.row].name
            setWhoAddedItem(cell: cell, indexPath: indexPath)
            cell.expiration.text = expDate(days: self.filteredItemList[indexPath.row].expirationDate)
            
            //TODO: ask about how to store images
            cell.itemPic.sd_setImage(with: URL(string: self.filteredItemList[indexPath.row].pic), placeholderImage: UIImage(named: "fakerecipe"))

        } else {
            cell.itemName.text = self.itemList[indexPath.row].name
            setWhoAddedItem(cell: cell, indexPath: indexPath)
            cell.expiration.text = expDate(days: self.itemList[indexPath.row].expirationDate)
            
            //TODO: ask about how to store images
            cell.itemPic.sd_setImage(with: URL(string: self.itemList[indexPath.row].pic), placeholderImage: UIImage(named: "fakerecipe"))
        }
        setRoundBorder(img: cell.itemPic)
        
        return cell
    }
    
    // OLD fetch image from firebase storage
    /*
    func fetchImage(firUrl: String) -> UIImage {
        let url = URL(string: firUrl)
        let data = try! Data(contentsOf: url!)
        
        return UIImage(data: data)!
        
    }
    */
    
    
    func setRoundBorder(img: UIImageView) {
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true;
        img.layer.borderWidth = 1.0;
        img.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor;
    }
    
    func expDate(days: Int) -> String {
        
        if (days < 30) {
            return "\(days)d"
        } else {
            // TODO : cap the days at a value, 30(?)
            return "\(days)d+"
        }
        
    }
    
    func setWhoAddedItem(cell: KitchenItemsTableViewCell, indexPath: IndexPath) {
        var list = itemList
        if isSearching {
            list = filteredItemList
        }
        let userId = list[indexPath.row].creatorId
        if (userId == curUser?.uid) {
            cell.addedBy.text = "added by me"
        } else {
            
            ref?.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get name value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? "some"
                let nameArr = name.components(separatedBy: " ")
                cell.addedBy.text = "added by " + nameArr[0]
            }) { (error) in
                print(error.localizedDescription)
                cell.addedBy.text = "added by someone"
            }
 
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isSearching {
                itemRef?.child(filteredItemList[indexPath.row].key).removeValue()
                filteredItemList.remove(at: indexPath.row)
                
            } else {
                itemRef?.child(itemList[indexPath.row].key).removeValue()
            }
            
            tableView.reloadData()
        }
    }
    
    
    @IBAction func cameraWasTapped(_ sender: UIBarButtonItem) {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("PopoverViewController") as! UIViewController
//        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.barButtonItem = sender
//        presentViewController(vc, animated: true, completion:nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showItemDetail" {
            if let cell = sender as? UITableViewCell {
                let i = table.indexPath(for: cell)!.row
                let vc = segue.destination as! ItemDetailViewController
                if isSearching {
                    vc.currentItem = self.filteredItemList[i]
                } else {
                    vc.currentItem = self.itemList[i]
                }
                
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            table.reloadData()
        } else {
            isSearching = true
            filteredItemList = itemList.filter({ item in
                return item.name.lowercased().contains(searchText.lowercased())
            })
            table.reloadData()
        }
    }

    
}
