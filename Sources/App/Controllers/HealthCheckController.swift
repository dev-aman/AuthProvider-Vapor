//
//  HealthCheckController.swift
//  AuthProvider
//
//  Created by Aman Gupta on 27/04/20.
//

import Vapor

struct HealthCheckController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let healthCheckRoutes = routes.grouped("api", "v1")
        healthCheckRoutes.get("health-check", use: healthCheck)
        healthCheckRoutes.post("foo", "boo", use: handler)
    }
    
    func healthCheck(req: Request) throws -> HealthCheck {
        return HealthCheck(status: .ok, message: "All services are running.")
    }
    
    func handler(req: Request) throws -> String {
        return "Hello foo"
    }
    
}

