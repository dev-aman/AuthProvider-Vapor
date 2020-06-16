//
//  Reminder.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Vapor
import Fluent

// new code explain this
final class Todo: Content, Model {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String

    @Field(key: "message")
    var message: String

    @Parent(key: "user_id")
    var user: User
        
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil,
         title: String,
         message: String,
         userId: UUID) {
        self.id = id
        self.title = title
        self.message = message
        self.$user.id = userId
    }
}

