//
//  AppDelegate.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()

        let env = ProcessInfo.processInfo.environment
        guard let publishableKey = env["stripe_publishable_key"] else {
            fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_publishable_key をセット")
        }
        guard let secretKey = env["stripe_secret_key"] else {
            fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_secret_key をセット")
        }
        guard let urlString = env["stripe_customer_key_url"],
            let customerKeyURL = URL(string: urlString) else {
            fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_customer_key_url をセット")
        }

        let striptAPIConfig = StripeAPIConfiguration.shared
        striptAPIConfig.publishableKey = publishableKey
        striptAPIConfig.secretKey = secretKey
        striptAPIConfig.customerKeyURL = customerKeyURL

        let stripeConfig = STPPaymentConfiguration.shared()
        stripeConfig.publishableKey = publishableKey
        stripeConfig.companyName = "Cookpad Inc."
        stripeConfig.requiredBillingAddressFields = .zip
        stripeConfig.requiredShippingAddressFields = .postalAddress
        stripeConfig.shippingType = .shipping
        stripeConfig.additionalPaymentMethods = .all

        return true
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

