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
    var groupKey : String = ""
    var userlist : [User] = []
    var groupRef : FIRDatabaseReference!
    var userGroupsRef : FIRDatabaseReference!
    

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var createdAt: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
        editPressed.isHidden = false
        donePressed.isHidden = true
        groupName.isUserInteractionEnabled = false
        //TODO: update group name
        if groupName.text?.characters != nil {
            updateGroupName(name: groupName.text!)
        }
    }
    
    @IBOutlet weak var editPressed: UIButton!
    @IBOutlet weak var donePressed: UIButton!
    @IBAction func editButton(_ sender: Any) {
        groupName.isUserInteractionEnabled = true
        groupName.becomeFirstResponder()
        donePressed.isHidden = false
        editPressed.isHidden = true
    }
    @IBOutlet weak var groupTableview: UITableView!
    var userRef : FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = FirebaseProxy.firebaseProxy.userRef
        loadGroupData()
        donePressed.isHidden = true
        groupRef = FirebaseProxy.firebaseProxy.groupRef
        userGroupsRef = FirebaseProxy.firebaseProxy.userGroupsRef
        
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
        //usersArr = Array(group.users.values.map{ $0 })
        for u in group.users {
            let user = User.init(key: u.key, dictionary: u.value as! Dictionary<String, AnyObject>)
            userlist.append(user)
        }
        
    }
    
    func updateGroupName(name: String) {
        groupRef.child(groupKey).updateChildValues(["name": name])
        
        //TODO : update group name for all users!!!
       // userGroupsRef.(fireba)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! GroupMemberTableViewCell
        cell.userName.text = userlist[indexPath.row].name
        cell.profilePic.sd_setImage(with: URL(string: userlist[indexPath.row].pic))
        let dietStr = userlist[indexPath.row].diet.joined(separator: ",")
        cell.allergy.text = "Preference: \(dietStr)"

        setRoundBorder(img: cell.profilePic)
        return cell
    }
    
    func setRoundBorder(img: UIImageView) {
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true
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
