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
}

extension StripeAPI {
    struct Order: Decodable {
        let id: String

        enum Request: StripeAPIRequest {
            case create(
                currency: Currency,
//            coupon: ?,
                customer: String?,
                email: String?,
                items: Items?,
                metadata: [String: String]?
//            shipping: [String: String]?
            )
            case retrieve

            public typealias Response = Order

            public var method: HTTPMethod {
                switch self {
                case .create: return .post
                case .retrieve: return .get
                }
            }

            public var path: String {
                return "orders"
            }

            public var queryParameters: [String: Any]? {
                switch self {
                case let .create(currency, customer, email, items, metadata):
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
                case .retrieve:
                    return nil
                }
            }
        }
    }
}

struct Items {
    let amount: Int?
    let currency: Currency?
    let description: String?
    let parent: String?
    let quantity: Int?
    let type: String?

    var formUrlEncodedValue: [String: Any] {
        var a: [String: Any] = [:]
        if let amount = amount {
            a["items[][amount]"] = amount
        }
        if let currency = currency {
            a["items[][currency]"] = currency
        }
        if let description = description {
            a["items[][description]"] = description
        }
        if let parent = parent {
            a["items[][parent]"] = parent
        }
        if let quantity = quantity {
            a["items[][quantity]"] = quantity
        }
        if let type = type {
            a["items[][type]"] = type
        }

        return a
    }
}

enum Currency: String, Decodable {
    case jpy
    case usd
}

class StripeSession: Session {

}

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
