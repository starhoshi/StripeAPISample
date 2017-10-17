//
//  StripeAPIRequest.swift
//  StripeAPISample
//
//  Created by kensuke-hoshikawa on 2017/10/13.
//  Copyright © 2017年 kensuke-hoshikawa. All rights reserved.
//

import Foundation
import APIKit
import Result

protocol StripeAPIRequest: Request {
}

extension StripeAPIRequest {
    var baseURL: URL {
        return URL(string: "https://api.stripe.com/v1/")!
    }

    var key: String {
        return StripeAPIConfiguration.secretKey
    }

    var encodedKey: String {
        print(key)
        let data: Data = self.key.data(using: String.Encoding.utf8)!
        return data.base64EncodedString()
    }

    var headerFields: [String: String] {
        return ["authorization": "Basic \(encodedKey)"]
    }

    var dataParser: DataParser {
        return DecodableDataParser()
    }
}

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}

extension StripeAPIRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data: Data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

extension StripeAPIRequest {
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
        guard let data: Data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        if let string = String(data: data, encoding: .utf8) {
            print("response: \(string)")
        }
        switch urlResponse.statusCode {
        case 200..<300:
            return object

        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
}
