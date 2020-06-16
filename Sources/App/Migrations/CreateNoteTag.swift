//
//  CreateNoteTag.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Vapor
import Fluent

struct CreateNoteTag: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(NoteTag.schema)
            .id()
            .field("note_id", .uuid, .required, .references(Note.schema, .id))
            .field("tag_id", .uuid, .required, .references(Tag.schema, .id))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(NoteTag.schema).delete()
    }
}

