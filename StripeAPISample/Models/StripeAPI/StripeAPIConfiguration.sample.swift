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
    static let shared = SampleStripeAPIConfiguration()
    private init () { }

    /// https://dashboard.stripe.com/account/apikeys
    var publishableKey = ""

    /// https://dashboard.stripe.com/account/apikeys
    var secretKey = ""

    /// https://github.com/stripe/example-ios-backend/tree/v11.0.0
    var customerKeyURL = URL(string: "https://your-example.heroku.com")
}
