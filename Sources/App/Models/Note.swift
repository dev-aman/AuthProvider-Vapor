//
//  Note.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Fluent
import Vapor

// new code explain this
final class Note: Content, Model {
    static let schema = "notes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String

    @Field(key: "message")
    var message: String

    @Parent(key: "user_id")
    var user: User
    
    @Siblings(through: NoteTag.self, from: \.$note, to: \.$tag)
    var tags: [Tag]
    
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


struct NoteUpdateModel: Content {
    var id: UUID
    var title: String?
    var message: String?
    
    init(id: UUID,
         title: String?,
         message: String?) {
        self.id = id
        self.title = title
        self.message = message
    }
}

struct NoteCreateModel: Content {
    var title: String
    var message: String
    var userId: UUID
    var tagIds: [UUID]?
    
    init(title: String,
         message: String,
         userId: UUID,
         tagIds: [UUID]?) {
        self.title = title
        self.message = message
        self.userId = userId
        self.tagIds = tagIds
    }
}

