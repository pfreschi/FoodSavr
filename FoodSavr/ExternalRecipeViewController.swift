//
//  ExternalRecipeViewController.swift
//  FoodSavr
//
//  Created by Peter Freschi on 5/23/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//
import UIKit
import SDWebImage
import Foundation
import Firebase
import Alamofire
import SwiftyJSON

class ExternalRecipeViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var storedRecipe : JSON = []
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let url = URL(string: storedRecipe["source"]["sourceRecipeUrl"].stringValue)!
    let req = URLRequest(url: url)
    webView.loadRequest(req)
    
    
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()


}




}

