import Fluent
import Vapor

struct FPSController : RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("trackFPS", use: saveFPS)
    }

    private func saveFPS(req: Request) throws -> EventLoopFuture<FPS> {
        let fps = try req.content.decode(FPS.self)
        return fps.save(on: req.db).map { fps }
    }
    
}
