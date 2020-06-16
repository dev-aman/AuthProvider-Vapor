//
//  NoteController.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Fluent
import Vapor

struct NoteController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let noteRoutes = routes.grouped("api", "v1", "notes")
        noteRoutes.post(use: createNoteHandler)
        noteRoutes.get(use: getAllNotesWithUser)
        noteRoutes.get(":id", use: getNote)
        noteRoutes.delete(":id", use: deleteNote)
        noteRoutes.put(use: updateNote)
        noteRoutes.post("add_tags", use: addTagsToNote)
    }
    
    func createNoteHandler(req: Request) throws -> EventLoopFuture<Note> {
        let reqModel = try req.content.decode(NoteCreateModel.self)
        
        let note = Note(title: reqModel.title, message: reqModel.message, userId: reqModel.userId)
        
        let tags = Tag.query(on: req.db).all().map { (tags) -> [Tag] in
            tags.filter { (tag) -> Bool in
                return reqModel.tagIds?.contains(tag.id ?? UUID()) ?? false
            }
        }
        return note
            .save(on: req.db)
            .map { note }
            .and(tags)
            .flatMap({ (note, tags) -> EventLoopFuture<Note> in
                return note.$tags.attach(tags, on: req.db).map({ () -> Note in
                    return note
                })
            })
    }
    
    func getAllNotesWithUser(req: Request) throws -> EventLoopFuture<[Note]> {
        return Note.query(on: req.db).with(\.$user).with(\.$tags).all()
    }
    
    func getNote(req: Request) throws -> EventLoopFuture<Note> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Note
            .query(on: req.db)
            .with(\.$user)
            .filter(.id, .equal, id)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteNote(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Note
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func updateNote(req: Request) throws -> EventLoopFuture<Note> {
        let tobeUpdatedNote = try req.content.decode(NoteUpdateModel.self)
        return Note
            .find(tobeUpdatedNote.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (note) -> EventLoopFuture<Note> in
                if let title = tobeUpdatedNote.title {
                    note.title = title
                }
                if let message = tobeUpdatedNote.message {
                    note.message = message
                }
                return note.save(on: req.db).map { note }
        }
    }
    
    func addTagsToNote(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let reqModel = try req.content.decode(NoteTagUpdateModel.self)
        let note = Note.find(reqModel.noteId, on: req.db)
            .unwrap(or: Abort(.notFound))
        let tag = Tag.query(on: req.db).filter(.id, .equal, reqModel.tagIds).all()
        return note.and(tag).flatMap({ (note, tag) in
            note.$tags.attach(tag, on: req.db)
        }).transform(to: .ok)
    }
}

