//
//  NoteTag.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Vapor
import Fluent

// new code explain this
final class NoteTag: Content, Model {
    static let schema = "note_tag"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "tag_id")
    var tag: Tag

    @Parent(key: "note_id")
    var note: Note

    init() {}

    init(tagId: UUID, noteId: UUID) {
        self.$tag.id = tagId
        self.$note.id = noteId
    }
}

