//
//  KitchenFeedViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class KitchenFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate{
    
    var ref : FIRDatabaseReference?
    var itemRef: FIRDatabaseReference?
    var itemList:[Item] = []
    var curUser : FIRUser?
     var imagePicker: UIImagePickerController!
    
    
    @IBOutlet weak var table: UITableView!
    
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
                        print("this is key" + item.name)
                        
                    }
                }
                self.itemList = newItems
                self.table.reloadData()
                
            }
            
            
        }) { (error) in
            print("there is error")
            
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

        return itemList.count
    }
    
    func setupUI() {
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KitchenItemsTableViewCell
        cell.itemName.text = self.itemList[indexPath.row].name
        //TODO: convert to name!
        //cell.addedby.text = self.itemList[indexPath.row].creatorId
        cell.expiration.text = expDate(days: self.itemList[indexPath.row].expirationDate)
        
        //TODO: ask about how to store images
        cell.itemPic.image = fetchImage(firUrl: self.itemList[indexPath.row].pic)
        setRoundBorder(img: cell.itemPic)
        
        return cell
    }
    
    // fetch image from firebase storage
    func fetchImage(firUrl: String) -> UIImage {
        let url = URL(string: firUrl)
        let data = try! Data(contentsOf: url!)
        
        return UIImage(data: data)!
        
    }
    
    
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
            return "\(days)d+"
        }
        
    }
    
    func addedByWho(userId: String) -> String {
        
        if (curUser?.uid == userId) {
            return "by me"
        } else {
            let userName = curUser?.displayName
            return "by \(String(describing: userName))"
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: delete item from database!
            itemList.remove(at: indexPath.row)
            
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
                 vc.currentItem = self.itemList[i]
                print(self.itemList[i])
                
            }
        }
    }
    
}
