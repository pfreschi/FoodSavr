//
//  ItemDetailViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/19/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
import Firebase

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentItem = Item(key:"none", dictionary: Dictionary<String, AnyObject>())
    var userGroupsRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    var groups : [Group] = []
    @IBOutlet weak var itemPic: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var expirationDate: UILabel!

    @IBOutlet weak var added: UILabel!
    
    @IBOutlet weak var groupsTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        userRef = FirebaseProxy.firebaseProxy.userRef
        groupsTableview.delegate = self
        groupsTableview.dataSource = self
        showitemInfo()
        fetchGroups()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showitemInfo() {
        itemName.text = currentItem.name
        expirationDate.text = "Expire in \(expDate(days: currentItem.expirationDate))"
        itemPic.sd_setImage(with: URL(string: currentItem.pic), placeholderImage: UIImage(named: "genericinventoryitem"))
        setRoundBorder(img: itemPic)
        self.title = "DETAIL"
        added.text = "Added by \(currentItem.creatorId)"
        
    }
    
    // fetch image from firebase storage
    func fetchImage(firUrl: String) -> UIImage {
        let url = URL(string: firUrl)
        let data = try! Data(contentsOf: url!)
        
        return UIImage(data: data)!
    }
    
    func getUsername(userId: String) {
//        userRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get name value
//            let value = snapshot.value as? NSDictionary
//            let name = value?["name"] as? String ?? "some"
//            let nameArr = name.components(separatedBy: " ")
//        }) { (error) in
//            print(error.localizedDescription)
//        }

    }
    func expDate(days: Int) -> String {
        
        if (days < 30) {
            return "\(days)d"
        } else {
            return "\(days)d+"
        }
    }
    
    
    func setRoundBorder(img: UIImageView) {
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true;
        img.layer.borderWidth = 1.0;
        img.layer.borderColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0).cgColor;
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharingCell", for: indexPath) as! SharingTableViewCell
        cell.groupName.text = groups[indexPath.row].name
        return cell
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
            self.groupsTableview!.reloadData()
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
