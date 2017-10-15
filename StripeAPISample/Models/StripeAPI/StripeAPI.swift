//
//  StripeAPI.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import APIKit
import Result

class StripeAPI {
}

extension StripeAPI {
    struct Customer {
        typealias RetrieveResponse = StripeAPI.Entity.Customer
        /// https://stripe.com/docs/api#retrieve_customer
        /// Retrieves the details of an existing customer. You need only supply the unique customer identifier that was returned upon customer creation.
        @discardableResult
        static func retrieve(customerID: String, handler: @escaping (Result<RetrieveResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = StripeAPI.Customer.RetrieveRequest(customerID: customerID)
            return Session.shared.send(request, handler: handler)
        }

        private struct RetrieveRequest: StripeAPIRequest {
            typealias Response = RetrieveResponse

            let customerID: String

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "customers/\(customerID)"
            }
        }

        typealias CreateResponse = StripeAPI.Entity.Customer
        /// https://stripe.com/docs/api#create_customer
        /// Creates a new customer object.
        @discardableResult
        static func create(email: String? = nil,
                           description: String? = nil,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = StripeAPI.Customer.CreateRequest(email: email, description: description)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let email: String?
            let description: String?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String : Any]? {
                var parameters: [String: Any] = [:]
                if let email = email {
                    parameters["email"] = email
                }
                if let description = description {
                    parameters["description"] = description
                }
                return parameters
            }

            var path: String {
                return "customers"
            }
        }
    }

    struct Product {
        typealias AllResponse = StripeAPI.Entity.ListResponse<StripeAPI.Entity.Product>
        /// https://stripe.com/docs/api#list_products
        /// Returns a list of your products. The products are returned sorted by creation date, with the most recently created products appearing first.
        @discardableResult
        static func all(handler: @escaping (Result<AllResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = StripeAPI.Product.AllRequest()
            return Session.shared.send(request, handler: handler)
        }

        private struct AllRequest: StripeAPIRequest {
            typealias Response = AllResponse

            var method: HTTPMethod {
                return .get
            }

            var path: String {
                return "products"
            }
        }
    }
}
