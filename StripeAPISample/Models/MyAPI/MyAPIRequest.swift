//
//  MyAPIRequest.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/16.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import APIKit

protocol MyAPIRequest: Request {
}

extension MyAPIRequest {
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

extension MyAPIRequest {
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
