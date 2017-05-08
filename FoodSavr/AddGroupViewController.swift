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

    @IBOutlet weak var memTableView: UITableView!
    
    @IBOutlet weak var memText: UITextField!
    
    @IBAction func addGroup(_ sender: Any) {
    }

    @IBOutlet weak var groupName: UITextField!
    @IBAction func Clear(_ sender: Any) {
        memText.text = ""
        groupName.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memTableView.delegate = self
        memTableView.dataSource = self
        memText.delegate = self
        memTableView.isHidden = true

        userRef = FirebaseProxy.firebaseProxy.userRef
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
                print(snapshots)
                for snap in snapshots {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = User(key: key, dictionary: userDict)
                        
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
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: AutoCompleteUserTableViewCell = memTableView.cellForRow(at: indexPath)! as! AutoCompleteUserTableViewCell
        
        //memText.text = trimFirstname(string: selectedCell.username!.text!)
        
        selectedVals.add(trimFirstname(string: selectedCell.username!.text!))
        memText.text = selectedVals.componentsJoined(by: ",")
        
    }
    
    func trimFirstname(string: String) -> String {
        return string.components(separatedBy: " ").first!
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
