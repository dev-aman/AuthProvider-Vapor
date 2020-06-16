import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
        
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateFPS())
    
    // new code explain this
    app.migrations.add(CreateNote())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateNoteTag())

    // register routes
    try routes(app)
}
