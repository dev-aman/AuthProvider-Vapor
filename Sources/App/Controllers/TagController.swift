//
//  TagController.swift
//  App
//
//  Created by Aman Gupta on 20/05/20.
//

import Fluent
import Vapor

struct TagController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let tagRoutes = routes.grouped("api", "v1", "tags")
        tagRoutes.post(use: createTag)
        tagRoutes.get(use: getAllTags)
        tagRoutes.get(":id", use: getTag)
        tagRoutes.delete(":id", use: deleteTag)
        tagRoutes.put(use: updateTag)
    }
    
    func createTag(req: Request) throws -> EventLoopFuture<Tag> {
        let tag = try req.content.decode(Tag.self)
        return tag.save(on: req.db).map { tag }
    }
    
    func getAllTags(req: Request) throws -> EventLoopFuture<[Tag]> {
        return Tag.query(on: req.db).withDeleted().all()
    }
    
    func getTag(req: Request) throws -> EventLoopFuture<Tag> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Tag
            .query(on: req.db)
            .filter(.id, .equal, id)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func deleteTag(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Tag
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func updateTag(req: Request) throws -> EventLoopFuture<Tag> {
        let tobeUpdatedTag = try req.content.decode(TagUpdateModel.self)
        return Tag
            .find(tobeUpdatedTag.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (tag) -> EventLoopFuture<Tag> in
                if let name = tobeUpdatedTag.name {
                    tag.name = name
                }
                return tag.save(on: req.db).map { tag }
        }
    }
}

