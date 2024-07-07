//
//  NetworkError.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation

enum NetworkError: Error {
    case notConnected
    case invalidURL
    case invalidResponse
    case badRequest
    case unauthorized
    case serverError
    case notFound
    case unknownError(statusCode: Int?)

    var message: String {
        switch self {
        case .notConnected:
            return "The device is not connected to the internet."
        case .invalidURL:
            return "The URL used for the network request is invalid."
        case .invalidResponse:
            return "The response from the server is invalid or cannot be parsed."
        case .badRequest:
            return "The request sent to the server is malformed or incorrect."
        case .unauthorized:
            return "The server rejected the request because it requires authentication or the provided credentials are invalid."
        case .serverError:
            return "The server encountered an internal error while processing the request."
        case .notFound:
            return "The requested resource was not found on the server."
        case .unknownError(let statusCode):
            if let code = statusCode {
                return "An unknown error occurred with status code: \(code)."
            } else {
                return "An unknown error occurred."
            }
        }
    }
}
