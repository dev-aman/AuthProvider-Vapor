//
//  WrongAPIKeyError.swift
//  App
//
//  Created by Aman Gupta on 19/05/20.
//

import Vapor

enum WrongAPIKeyError {
    case invalidAPIKey
}

extension WrongAPIKeyError: AbortError {
    var reason: String {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key"
        }
    }

    var status: HTTPStatus {
        switch self {
        case .invalidAPIKey:
            return .badRequest
        }
    }
}
