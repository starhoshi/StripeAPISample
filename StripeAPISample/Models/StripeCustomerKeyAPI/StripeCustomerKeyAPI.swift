//
//  StripeCustomerKeyAPI.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/16.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import Stripe

class StripeCustomerKeyAPI: NSObject, STPEphemeralKeyProvider {
    static let shared = StripeCustomerKeyAPI()
    private override init () { }

    var url: URL {
        if let url = StripeAPIConfiguration.shared.customerKeyURL {
            return url
        }

        fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_customer_key_url をセット")
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch let error {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
}
