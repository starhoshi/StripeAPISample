//
//  StripeAPIConfiguration.sample.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/16.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation

// rename to StripeAPIConfiguration and set parameters
class SampleStripeAPIConfiguration {
    /// https://dashboard.stripe.com/account/apikeys
    static let publishableKey = "pk_test_xxxxxx"

    /// https://dashboard.stripe.com/account/apikeys
    static let secretKey = "sk_test_xxxxxxxx"

    /// https://github.com/stripe/example-ios-backend/tree/v11.0.0
    static let customerKeyURL = URL(string: "https://hoge.com")!
}

