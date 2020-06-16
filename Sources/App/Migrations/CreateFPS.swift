import Fluent

struct CreateFPS: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FPS.schema)
            .id()
            .field("name", .string, .required)
            .field("platform", .string, .required)
            .field("build_number", .string, .required)
            .field("elapsed_frames", .int64, .required)
            .field("broken_frames", .int64, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}
