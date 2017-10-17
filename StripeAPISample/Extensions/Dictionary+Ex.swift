//
//  Dictionary+Ex.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/17.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation

func += <K, V> (left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}
