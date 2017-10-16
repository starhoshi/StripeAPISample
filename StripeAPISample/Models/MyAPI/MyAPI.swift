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
        return StripeAPIConfiguration.customerKeyURL
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
                return "ephemeral_keys"
            }

            func response(from object: Any, urlResponse: HTTPURLResponse) throws -> CreateResponse {
                guard let data: Data = object as? Data else {
                    throw ResponseError.unexpectedObject(object)
                }
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            }
        }
    }

    struct Charge {
        typealias CreateResponse = Void
        /// https://stripe.com/docs/api#create_customer
        /// Creates a new customer object.
        @discardableResult
        static func create(result: STPPaymentResult,
                           amount: Int,
                           shippingAddress: STPAddress? = nil,
                           shippingMethod: PKShippingMethod? = nil,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(result: result,
                                        amount: amount,
                                        shippingAddress: shippingAddress,
                                        shippingMethod: shippingMethod)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: MyAPIRequest {
            func response(from object: Any, urlResponse: HTTPURLResponse) throws -> MyAPI.Charge.CreateResponse {
                // Void
            }

            typealias Response = CreateResponse

            let result: STPPaymentResult
            let amount: Int
            let shippingAddress: STPAddress?
            let shippingMethod: PKShippingMethod?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [
                    "source": result.source.stripeID,
                    "amount": amount
                ]
//                parameters["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
                return parameters
            }

            var path: String {
                return "charge"
            }
        }
    }
}
