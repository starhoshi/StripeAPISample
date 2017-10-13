//
//  MainTabBarViewController.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import UIKit

final class MainTabBarViewController: UITabBarController {
    let productsVC: ProductsViewController = {
        let vc = ProductsViewController()
        let item = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.favorites, tag: 0)
        vc.tabBarItem = item
        return vc
    }()
    let cartVC: CartViewController = {
        let vc = CartViewController()
        let item = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.bookmarks, tag: 0)
        vc.tabBarItem = item
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nav = UINavigationController(rootViewController: productsVC)
        let nav2 = UINavigationController(rootViewController: cartVC)
        setViewControllers([nav, nav2], animated: false)
    }
}
