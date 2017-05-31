 //
//  AppDelegate.swift
//  FoodSavr
//
//  Created by Peter Freschi on 3/31/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        customizeAppearance()
        // Override point for customization after application launch.
        
        
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if  UserDefaults.standard.value(forKey: "uid") == nil {
                //let vc = storyboard.instantiateViewController(withIdentifier: "tabBar")
                let vc = AuthenticationViewController()
                self.window?.rootViewController?.present(vc, animated: false, completion: nil)
            } else {
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBar")
                self.window?.rootViewController = vc
            }
        
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let yummlyAppId = dict["yummlyAppId"] as? String
            let yummlyAppKey = dict["yummlyAppKey"] as? String
            
            // Save Yummly info to UserDefaults
            UserDefaults.standard.set(yummlyAppId, forKey: "yummlyAppId")
            UserDefaults.standard.set(yummlyAppKey, forKey: "yummlyAppKey")
        }
        
        // store a list of ingredients to user default
        getIngredients() { (ingredients: [String]?) in
            UserDefaults.standard.set(ingredients!, forKey: "ingredients")
        }
    
        return true
    }
    
    // get a list of ingredients and save them to userdefault
    func getIngredients(completionHandler:@escaping (_ ingredients: [String]?) -> ()) {
        
        FirebaseProxy.firebaseProxy.myRootRef.child("ingredients").queryOrdered(byChild: "term").observeSingleEvent(of: .value, with: {(snapshot) in
            var ingredients : [String] = []
            let result = snapshot.value as! NSArray
            
            for r in result as Array {
                ingredients.append(r["term"]! as! String)
 
            }
            
            if ingredients.isEmpty {
                completionHandler(nil)
            }else {
                completionHandler(ingredients)
            }
        })
    }
    
    
    
    func customizeAppearance() {
        //top nav bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 155.0/255.0, green: 198.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
