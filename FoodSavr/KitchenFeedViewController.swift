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

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}


class KitchenFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UISearchBarDelegate{
    
    var ref : FIRDatabaseReference?
    var itemRef: FIRDatabaseReference?
    var userRef : FIRDatabaseReference?
    var userGroupsRef : FIRDatabaseReference?
    var groupIDs = Set<String>()
    var itemList:[Item] = []
    var filteredItemList:[Item] = []
    var curUser : FIRUser?
    var nameArr : [String] = []
    var imagePicker: UIImagePickerController!
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        ref = FirebaseProxy.firebaseProxy.myRootRef
        itemRef = FirebaseProxy.firebaseProxy.itemRef
        userRef = FirebaseProxy.firebaseProxy.userRef
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        curUser = (FIRAuth.auth()?.currentUser)!
        fetchGroups()
        itemRef?.queryOrdered(byChild: "expirationDate").observe(.value, with: { (snapshot) in
            
            var newItems : [Item] = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let itemDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let item = Item(key: key, dictionary: itemDict)
                        
                        // only added if item is created by current user or user is in the group
                        if item.creatorId == self.curUser?.uid {
                            newItems.append(item)
                            //calculate expirtation date
                            item.expirationDate = self.calculateExpDate(days: item.expirationDate, createdDate: item.dateAdded)
                        }
                        
                        if itemDict.index(forKey: "groups") != nil {
                            let keys = Set(item.groups.keys)
                            // get the common groupID back
                            //let filter = keys.filter() {self.groupIDs.contains($0)}
                            if keys.isSubset(of: self.groupIDs) {
                                newItems.append(item)
                                //calculate expirtation date
                                item.expirationDate = self.calculateExpDate(days: item.expirationDate, createdDate: item.dateAdded)
                            }
                        }
                    }
                }
                
                self.itemList = newItems
                
                
                // save all items to userdefault
                var itemNames : [String] = []
                for i in newItems {
                    itemNames.append(i.name)
                }
                UserDefaults.standard.set(itemNames, forKey: "inventory")
                UserDefaults.standard.synchronize()
                
                // sort the table by expiration date
                self.itemList.sort(by: { $0.expirationDate < $1.expirationDate } )
                self.table.reloadData()
            }
        }) { (error) in
            
            print("this is error" + error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func fetchGroups() {
        var userGroupIDs = Set<String>()
        userGroupsRef?.child((curUser?.uid)!).observeSingleEvent(of: .value , with: {(snapshot) in
            if let groupDict = snapshot.value as? Dictionary<String, AnyObject>{
                for (_, value) in groupDict {
                    let data = value as! Dictionary<String, Any>
                    userGroupIDs.insert(data["id"]! as! String)
                }
            }
            self.groupIDs = userGroupIDs
            
        })
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
            let i = self.filteredItemList[indexPath.row]
            cell.itemName.text = i.name
            setWhoAddedItem(cell: cell, indexPath: indexPath)
            cell.expiration.text = expDate(days: self.filteredItemList[indexPath.row].expirationDate)
            // make the text red!
            if (i.expirationDate) < 0 {
                cell.expiration.textColor = UIColor(red:244.0/255.0, green: 89.0/255.0, blue: 66.0/255.0, alpha: 1.0)
                
                setRoundBorder(img: cell.itemPic, color: UIColor(red:244.0/255.0, green: 89.0/255.0, blue: 66.0/255.0, alpha: 1.0))
                
            } else {
                setRoundBorder(img: cell.itemPic, color: UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0))
                
            }

            
//            let expIndays = calculateExpDate(days: i.expirationDate, createdDate: i.dateAdded)
//            cell.expiration.text = "\(expIndays)"
            
            cell.itemPic.sd_setImage(with: URL(string: i.pic), placeholderImage: UIImage(named: "genericinventoryitem"))

        } else {
            let i = self.itemList[indexPath.row]
            cell.itemName.text = i.name
            setWhoAddedItem(cell: cell, indexPath: indexPath)
            cell.expiration.text = expDate(days: i.expirationDate)
            // make the text red!
            if (i.expirationDate) < 0 {
                cell.expiration.textColor = UIColor(red:244.0/255.0, green: 89.0/255.0, blue: 66.0/255.0, alpha: 1.0)
                setRoundBorder(img: cell.itemPic, color: UIColor(red:244.0/255.0, green: 89.0/255.0, blue: 66.0/255.0, alpha: 1.0))
                
            } else {
                setRoundBorder(img: cell.itemPic, color: UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0))
                
            }
            cell.itemPic.sd_setImage(with: URL(string: i.pic), placeholderImage: UIImage(named: "genericinventoryitem"))
//            let expIndays = calculateExpDate(days: i.expirationDate, createdDate: i.dateAdded)
//            cell.expiration.text = "\(expIndays)"
        }
        

        
        
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
    
    
    func setRoundBorder(img: UIImageView, color: UIColor) {
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true;
        img.layer.borderWidth = 1.0;
        img.layer.borderColor = color.cgColor;
    }
    
    func calculateExpDate(days: Int, createdDate: String) -> Int {
        let localeStr = "en_US"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeStr)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: createdDate)
        let now = Date()
        let expirationDate = Calendar.current.date(byAdding: .day, value: days, to: date!)

        let timeOffset = expirationDate!.interval(ofComponent: .day, fromDate: now)
        return timeOffset
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
            self.nameArr.append("me")
        } else {
            
            ref?.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get name value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? "some"
                self.nameArr = name.components(separatedBy: " ")
                cell.addedBy.text = "added by " + self.nameArr[0]
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
    
    
//  @IBAction func cameraWasTapped(_ sender: UIBarButtonItem) {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("PopoverViewController") as! UIViewController
//        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.barButtonItem = sender
//        presentViewController(vc, animated: true, completion:nil)
//}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showItemDetail" {
            if let cell = sender as? UITableViewCell {
                let i = table.indexPath(for: cell)!.row
                let vc = segue.destination as! ItemDetailViewController
                if isSearching {
                    vc.currentItem = self.filteredItemList[i]
                    vc.itemKey = self.filteredItemList[i].key
                } else {
                    vc.currentItem = self.itemList[i]
                    vc.itemKey = self.itemList[i].key
                }
                vc.creatorName = self.nameArr[0]
                
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
