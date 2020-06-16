//
//  CreateTag.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Vapor
import Fluent

struct CreateTag: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Tag.schema)
            .id()
            .field("name", .string)
            .field("created_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Tag.schema).delete()
    }
}
