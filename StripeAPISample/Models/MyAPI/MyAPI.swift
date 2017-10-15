//
//  MyAPI.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/16.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import Stripe
import APIKit
import Result

class MyAPI: NSObject, STPEphemeralKeyProvider {
    static let shared = MyAPI()
    private override init () { }

    var url: URL {
        if let url = StripeAPIConfiguration.shared.customerKeyURL {
            return url
        }

        fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_customer_key_url をセット")
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        MyAPI.EphemeralKey.create(apiVersion: apiVersion) { result in
            print(result)
            switch result {
            case .success(let response):
                completion(response, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension MyAPI {
    struct EphemeralKey {
        typealias CreateResponse = [String: AnyObject]?
        /// https://stripe.com/docs/api#create_customer
        /// Creates a new customer object.
        @discardableResult
        static func create(apiVersion: String = "2015-10-12",
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(apiVersion: apiVersion)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: MyAPIRequest {
            typealias Response = CreateResponse

            let apiVersion: String

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                parameters["api_version"] = apiVersion
                return parameters
            }

            var path: String {
                return ""
            }

            func response(from object: Any, urlResponse: HTTPURLResponse) throws -> CreateResponse {
                guard let data: Data = object as? Data else {
                    throw ResponseError.unexpectedObject(object)
                }
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            }
        }
    }
}
