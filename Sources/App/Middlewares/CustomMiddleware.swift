//
//  CustomMiddleware.swift
//  App
//
//  Created by Aman Gupta on 19/05/20.
//

import Vapor

struct CustomMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard request.headers.contains(name: "APIKey") && request.headers.first(name: "APIKey") == "ABCDE" else {
            return request.eventLoop.makeFailedFuture(WrongAPIKeyError.invalidAPIKey)
        }
        return next.respond(to: request)
    }
}


