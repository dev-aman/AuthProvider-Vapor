//
//  User.swift
//  AuthProvider
//
//  Created by Aman Gupta on 26/04/20.
//

import Fluent
import Vapor

final class User: Content, Model {
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}

struct UserUpdateModel: Content {
    var id: UUID
    var name: String?
    
    init(id: UUID, name: String?) {
        self.id = id
        self.name = name
    }
}
