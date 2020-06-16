//
//  Tag.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Vapor
import Fluent

// new code explain this
final class Tag: Content, Model {
    static let schema = "tags"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: NoteTag.self, from: \.$tag, to: \.$note)
    var notes: [Note]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil,
         name: String) {
        self.id = id
        self.name = name
    }
}

struct TagUpdateModel: Content {
    var id: UUID
    var name: String?
    
    init(id: UUID,
         name: String?) {
        self.id = id
        self.name = name
    }
}

struct NoteTagUpdateModel: Content {
    let noteId: UUID
    let tagIds: [UUID]

    init(noteId: UUID,
         tagIds: [UUID]) {
        self.noteId = noteId
        self.tagIds = tagIds
    }
}
