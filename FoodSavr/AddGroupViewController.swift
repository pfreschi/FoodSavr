//
//  AddGroupViewController.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/29/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase

class AddGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var users = [User]()
    var autoComplete = [User]()
    var userRef : FIRDatabaseReference?
    var selectedVals : NSMutableArray = []
    var selectedUsers: [String] = []
    var groupRef : FIRDatabaseReference?

    @IBOutlet weak var memTableView: UITableView!
    
    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var memText: UITextField!
    
    @IBAction func addGroup(_ sender: Any) {
        createGroup(gName: groupName.text!, users: selectedUsers)
    }

    @IBOutlet weak var groupName: UITextField!
    @IBAction func Clear(_ sender: Any) {
        memText.text = ""
        groupName.text = ""
        selectedVals = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memTableView.delegate = self
        memTableView.dataSource = self
        memText.delegate = self
        memTableView.isHidden = true

        userRef = FirebaseProxy.firebaseProxy.userRef
        groupRef = FirebaseProxy.firebaseProxy.groupRef
        fetchUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        memTableView.isHidden = false
        let input = memText.text?.components(separatedBy: ",")
        
        if ((input?.last?.characters.count)! > 0) {
            let lastWord = input?.last!
            searchAutcomplete(substring: lastWord!)
        }
        return true
    }
    
    func searchAutcomplete(substring: String) {
        
        autoComplete.removeAll(keepingCapacity: false)
        for u in users {
            //print(u.name)
           // let curInput = memText.text! as NSString
            let myString: NSString! = u.name as NSString
            //let substringRange = curInput?.range(of: substring)
            let substringRange: NSRange! = myString.range(of: substring, options: NSString.CompareOptions.caseInsensitive)
            if (substringRange.location == 0) {
                autoComplete.append(u)
            }
        }
        self.memTableView.reloadData()
        
    }
    
    func fetchUsers() {
        userRef?.observe(.value, with: {(snapshot) in
            var userlist : [User] = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = User(key: key, dictionary: userDict)
                        // TODO: don't show the current user him/herself
                        print(user)
                        userlist.append(user)
                    }
                }
                self.users = userlist
                self.memTableView.reloadData()
            }
        
        }) {(error) in
            print("this is error" + error.localizedDescription)
                
        }
        
    }
    
    
    // MARK: - UITableViewDataSource
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: change to count
        return autoComplete.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutoCompleteUserTableViewCell
        
        cell.username.text = self.autoComplete[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: self.autoComplete[indexPath.row].pic)!)
        cell.profilePic.image = UIImage(data: data!)
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
        cell.profilePic.clipsToBounds = true;
        cell.key = self.autoComplete[indexPath.row].key
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: AutoCompleteUserTableViewCell = memTableView.cellForRow(at: indexPath)! as! AutoCompleteUserTableViewCell
        
        selectedUsers.append(selectedCell.key)
        
        selectedVals.add(trimFirstname(string: selectedCell.username!.text!))
        memText.text = selectedVals.componentsJoined(by: ",")
        
    }
    
    func trimFirstname(string: String) -> String {
        return string.components(separatedBy: " ").first!
    }
    
    func createGroup(gName: String, users: [String] ){
        if (groupName.text!.isEmpty || selectedUsers.count == 0) {
            warning.text = "Please fill out all the information!"
        } else {
            //check if it's logged in
            if (FIRAuth.auth()?.currentUser) != nil {
                // add current user into member list
                selectedUsers.append(FirebaseProxy.firebaseProxy.getCurrentUser())
                let members = getUserObjfromID(userIDs: selectedUsers)
                FirebaseProxy.firebaseProxy.saveGroup(name: gName,
                creatorId: (FIRAuth.auth()?.currentUser?.uid)!, members: members)
            }
        }
    }
    
    func getUserObjfromID(userIDs: Array<String>) -> [User] {
        var userlist : [User] = []
        
        for u in userIDs {
            let user = self.users.first(where: {$0.key == u})
            userlist.append(user!)
        }
        return userlist
    }
    


}
