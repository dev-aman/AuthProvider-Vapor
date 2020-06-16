//
//  CreateNote.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Fluent
import Vapor

struct CreateNote: Migration {
    // Prepares the database for storing Note models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Note.schema)
            .id()
            .field("title", .string)
            .field("message", .string)
            .field("user_id", .uuid, .references(User.schema, .id))
//            .field("tags", .array(of: .uuid), .references(Tag.schema, .id))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Note.schema).delete()
    }
}

