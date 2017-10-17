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
            let request = RetrieveRequest(customerID: customerID)
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
            let request = CreateRequest(email: email, description: description)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let email: String?
            let description: String?

            var method: HTTPMethod {
                return .post
            }

            var queryParameters: [String: Any]? {
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
            let request = AllRequest()
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

    /// https://stripe.com/docs/api#orders
    struct Order {
        typealias CreateResponse = StripeAPI.Entity.Order
        /// https://stripe.com/docs/api#create_order
        /// Creates a new order object.
        @discardableResult
        static func create(currency: StripeAPI.Entity.Currency,
                           customer: String?,
                           email: String?,
                           items: Items?,
                           metadata: [String: String]?,
                           handler: @escaping (Result<CreateResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = CreateRequest(currency: currency, customer: customer, email: email, items: items, metadata: metadata)
            return Session.shared.send(request, handler: handler)
        }

        private struct CreateRequest: StripeAPIRequest {
            typealias Response = CreateResponse

            let currency: StripeAPI.Entity.Currency
//            let coupon: Any
            let customer: String?
            let email: String?
            let items: Items?
            let metadata: [String: String]?
//            let shipping: [String: String]?

            var method: HTTPMethod {
                return .post
            }

            public var path: String {
                return "orders"
            }

            public var queryParameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                parameters["currency"] = currency.rawValue
                if let customer = customer {
                    parameters["customer"] = customer
                }
                if let email = email {
                    parameters["email"] = email
                }
                if let items = items {
                    parameters += items.formUrlEncodedValue
                }
                if let metadata = metadata {
                    parameters["metadata"] = metadata
                }
                return parameters
            }
        }


        typealias PayResponse = StripeAPI.Entity.Order
        /// https://stripe.com/docs/api#create_order
        /// Creates a new order object.
        @discardableResult
        static func pay(order: StripeAPI.Entity.Order,
                        customer: String? = nil,
                        email: String? = nil,
                        metadata: [String: String]? = nil,
                        handler: @escaping (Result<PayResponse, SessionTaskError>) -> Void) -> SessionTask? {
            let request = PayRequest(order: order, customer: customer, email: email, metadata: metadata)
            return Session.shared.send(request, handler: handler)
        }

        private struct PayRequest: StripeAPIRequest {
            typealias Response = PayResponse

            let order: StripeAPI.Entity.Order
            let customer: String?
//            let source: Source
//            let applicationFee:
            let email: String?
            let metadata: [String: String]?

            var method: HTTPMethod {
                return .post
            }

            public var path: String {
                return "orders/\(order.id)"
            }

            public var queryParameters: [String: Any]? {
                var parameters: [String: Any] = [:]
                if let customer = customer {
                    parameters["customer"] = customer
                }
                if let email = email {
                    parameters["email"] = email
                }

                if let metadata = metadata {
                    parameters["metadata"] = metadata
                }
                return parameters
            }
        }
    }
}
