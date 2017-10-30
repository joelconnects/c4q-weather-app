//
//  AppDelegate.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/29/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let appController = AppController()
    
    let frame = UIScreen.main.bounds
    window = UIWindow(frame: frame)
    
    if let window = window {
      window.rootViewController = appController
      window.makeKeyAndVisible()
    }
    
    return true
  }
}

