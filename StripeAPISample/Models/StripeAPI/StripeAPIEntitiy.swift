//
//  StripeAPIEntitiy.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation

extension StripeAPI {
    struct Entity {
    }
}

extension StripeAPI.Entity {
    struct ListResponse<T: Decodable>: Decodable {
        let object: String
        let url: String
        let has_more: Bool
        let data:[T]
    }

    struct Customer: Decodable {
        let id: String
        let object: String
        let accountBalance: Int
        let created: TimeInterval
        let currency: String?
        let defaultSource: String?
        let delinquent: Bool
        //    let description: String?
        //    let discount: String?
        let email: String?
        let livemode: Bool
        //    let metadata: Any?

        private enum CodingKeys: String, CodingKey {
            case id
            case object
            case accountBalance = "account_balance"
            case created
            case currency
            case defaultSource = "default_source"
            case delinquent
            case email
            case livemode
        }
    }

    struct Product: Decodable {
        let id: String
        let object: String
        let active: Bool
        let attributes: [String]
        let caption: String
        let created: TimeInterval
        //        let deactivate_on: [?]
        let description: String?
        let images: [URL]
        let livemode: Bool
        let metadata: [String: String]
        let name: String
        let packageDimensions: PackageDimensions
        let shippable: Bool
        let skus: SKUs
        let updated: TimeInterval
        let url: String?

        private enum CodingKeys: String, CodingKey {
            case id
            case object
            case active
            case attributes
            case caption
            case created
            case description
            case images
            case livemode
            case metadata
            case name
            case packageDimensions = "package_dimensions"
            case shippable
            case skus
            case updated
            case url
        }
    }

    struct SKUs: Decodable {
        let object: String
        let hasMore: Bool
        let totalCount: Int
        let url: String
        let data: [SKU]

        private enum CodingKeys: String, CodingKey {
            case object
            case hasMore = "has_more"
            case totalCount = "total_count"
            case url
            case data
        }
    }

    struct SKU: Decodable {
        let id: String
        let object: String
        let active: Bool
        let attributes: [String: String]
        let created: TimeInterval
        let currency: Currency
        let image: URL?
        let inventory: Inventory
        let livemode: Bool
        //        let metadata: [:]
        let packageDimensions: PackageDimensions?
        let price: Int
        let product: String
        let updated: TimeInterval

        private enum CodingKeys: String, CodingKey {
            case id
            case object
            case active
            case attributes
            case created
            case currency
            case image
            case inventory
            case livemode
            case packageDimensions = "package_dimensions"
            case price
            case product
            case updated
        }
    }

    struct Inventory: Decodable {
        enum InventoryType: String, Decodable {
            case finite, bucket, infinite
        }

        enum BucketValue: String, Decodable {
            case limited, out_of_stock, in_stock
        }

        let quantity: Int?
        let type: InventoryType
        let value: BucketValue?
    }

    struct PackageDimensions: Decodable {
        let height: Float
        let length: Float
        let weight: Float
        let width: Float
    }

    enum Currency: String, Decodable {
        case jpy
        case usd
    }

    struct Order: Decodable {
        let id: String
    }
}

struct Items {
    let amount: Int?
    let currency: StripeAPI.Entity.Currency?
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
