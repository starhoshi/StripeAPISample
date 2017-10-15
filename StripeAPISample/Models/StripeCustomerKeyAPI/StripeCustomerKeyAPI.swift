//
//  StripeCustomerKeyAPI.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/16.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import Stripe
import APIKit
import Result

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
        StripeCustomerKeyAPI.EphemeralKey.create(apiVersion: apiVersion) { result in
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

protocol StripeCustomerKeyAPIRequest: Request {
}

extension StripeCustomerKeyAPIRequest {
    var baseURL: URL {
        if let url = StripeAPIConfiguration.shared.customerKeyURL {
            return url
        }

        fatalError("Product > Scheme > Edit Scheme > Environment Variables に stripe_customer_key_url をセット")
    }

    var dataParser: DataParser {
        return DecodableDataParser()
    }
}

extension StripeCustomerKeyAPIRequest {
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.timeoutInterval = 10.0

        print("requestURL: \(urlRequest)")
        print("requestHeader: \(urlRequest.allHTTPHeaderFields!)")
        print("requestBody: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8).debugDescription)")
        return urlRequest
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        print("raw response header: \(urlResponse)")
        print("raw response body: \(object)")
        switch urlResponse.statusCode {
        case 200..<300:
            return object

        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
}

extension StripeCustomerKeyAPI {
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

        private struct CreateRequest: StripeCustomerKeyAPIRequest {
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
