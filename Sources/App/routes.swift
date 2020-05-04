import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get("hello", ":name") { (req) -> String in
        guard let name = req.parameters.get("name", as: String.self) else {
            return ""
        }
        return "Hello \(name)!"
    }
    
    try app.register(collection: HealthCheckController())
    try app.register(collection: UserController())
}
