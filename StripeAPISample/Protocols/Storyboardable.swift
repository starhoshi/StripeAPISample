//
//  Storyboardable.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return className
    }

    static func instantiate() -> Self {
        return UIStoryboard(
            name: storyboardName,
            bundle: Bundle(for: self)
            ).instantiateInitialViewController() as! Self
    }
}
