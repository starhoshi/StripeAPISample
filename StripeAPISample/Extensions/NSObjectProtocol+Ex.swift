//
//  NSObjectProtocol+Ex.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {
    public static var className: String {
        return String(describing: self)
    }
}
