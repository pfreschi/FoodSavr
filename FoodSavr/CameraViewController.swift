//
//  FirstViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 3/31/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth




class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var storageRef: FIRStorageReference!
    var auth : FIRAuth!
    var imagePicker: UIImagePickerController!
    let receiptRef = FirebaseProxy.firebaseProxy.receiptRef

    override func viewDidLoad() {
        super.viewDidLoad()
        // receipts storage
        storageRef = FIRStorage.storage().reference().child("receipts")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func takePhoto(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera))  {
        
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
        
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("the device does not have a camera")
            //imagePicker.sourceType = .photoLibrary
        }
    }
    
    
    @IBOutlet var imageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // make sure user is logged in
        if FIRAuth.auth()?.currentUser != nil {
            print("priting user uid: \(FIRAuth.auth()!.currentUser!.uid)")
            let uid = FIRAuth.auth()!.currentUser!.uid
            guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            guard let imageData = UIImageJPEGRepresentation(pickedImage, 0.8) else { return }
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // file path: receipts/uid/image.jpg
            let fileName = uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            self.storageRef.child(fileName)
            .put(imageData, metadata: metadata) {(metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.uploadSuccess(metadata!, storagePath: fileName)
                
            }

            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            print("Please sign in")
        }
    }
    
    
    
    func uploadSuccess(_ metadata: FIRStorageMetadata, storagePath: String) {
        print("Upload successed!")
        let imgURL = metadata.downloadURL()?.absoluteString
        
        FirebaseProxy.firebaseProxy.saveReceipt(pic: imgURL!, creatorId: FIRAuth.auth()!.currentUser!.uid,
             items: ["Apples", "Eggs","Milk"], vendor: "Safeway")
        
        //storage for user defaults??
//        UserDefaults.standard.set(receiptURL, forKey: "receiptURL")
//        UserDefaults.standard.synchronize()
 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}
