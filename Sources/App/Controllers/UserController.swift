//
//  UserController.swift
//  AuthProvider
//
//  Created by Aman Gupta on 26/04/20.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        // localhost:8080/api/v1/users POST
        // localhost:8080/api/v1/users GET
        // localhost:8080/api/v1/users/828093128 GET
        let userRoutes = routes.grouped("api", "v1")
        userRoutes.post("users", use: createHandler)
        userRoutes.get("users", use: getAllUsers)
        userRoutes.get("users", ":id", use: getUser)
        userRoutes.get("user", ":username", use: getUserForUserName)
        userRoutes.delete("users", ":id", use: deleteUser)
        userRoutes.put("users", use: updateUser)
    }
    
    func createHandler(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
    func getAllUsers(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).withDeleted().all()
    }
    
    func getUser(req: Request) throws -> EventLoopFuture<User> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return User
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func getUserForUserName(req: Request) throws -> EventLoopFuture<User> {
        guard let userName = req.parameters.get("username", as: String.self) else {
            throw Abort(.badRequest)
        }
        return User
            .query(on: req.db)
            .filter(\User.$username == userName)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return User
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func updateUser(req: Request) throws -> EventLoopFuture<User> {
        let updatedUser = try req.content.decode(UserUpdateModel.self)
        return User
            .find(updatedUser.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (user) -> EventLoopFuture<User> in
                if let name = updatedUser.name {
                    user.name = name
                }
                return user.save(on: req.db).map { user }
        }
    }
}

