//
//  AppDelegate.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.12.2024.
//

import UIKit
import AppsFlyerLib

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = AppConstants.appsflyerKey
        AppsFlyerLib.shared().appleAppID = AppConstants.appID
        AppsFlyerLib.shared().isDebug = true
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    @objc private func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
    
}
