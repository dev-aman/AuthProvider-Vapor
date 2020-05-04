//
//  HealthCheck.swift
//  AuthProvider
//
//  Created by Aman Gupta on 27/04/20.
//

import Vapor

struct HealthCheck: Content {
    let status: HTTPStatus
    let message: String
}



