//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing Realm \(error)")
        }
        
        return true
    }
}

