//
//  FirstViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 3/31/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        }
    }
    @IBOutlet var imageView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            print("image taken: \(pickedImage)")
        }
        self.dismiss(animated: true, completion: nil)
        //pickedImage.image  = info[UIImagePickerControllerOriginalImage] as! UIImage!;﻿
    }


}

