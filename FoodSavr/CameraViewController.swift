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



class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Firebase services
    // do we reference this from the firebaseproxy class??
    //var database: FIRDatabase!
    //var auth: FIRAuth!
    var storageRef: FIRStorageReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        storageRef = FIRStorage.storage().reference().child("receipts")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var imagePicker: UIImagePickerController!
    

 
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
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(pickedImage, 0.8) else { return }
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        self.storageRef.child("\(NSUUID().uuidString).jpg")
        .put(imageData, metadata: metadata) {(metadata, error) in
            if error == nil {
                print("success")
            } else {
                print(error?.localizedDescription)
            }
//                guard let metadata = metadata else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
//                // Metadata contains file metadata such as size, content-type, and download URL.
//                let downloadURL = metadata.downloadURL
//                print("hi \(downloadURL)")
            }

            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            print("image taken: \(pickedImage)")

        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    



}

