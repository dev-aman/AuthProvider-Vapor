import Fluent
import Vapor

final class FPS: Model, Content {
    static let schema = "fps"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "platform")
    var platform: String

    @Field(key: "build_number")
    var buildNumber: String

    @Field(key: "elapsed_frames")
    var elapsedFrames: Int64

    @Field(key: "broken_frames")
    var brokenFrames: Int64

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, name: String, platform: String, buildNumber: String, elapsedFrames: Int64, brokenFrames: Int64) {
        self.id = id
        self.name = name
        self.platform = platform
        self.buildNumber = buildNumber
        self.elapsedFrames = elapsedFrames
        self.brokenFrames = brokenFrames
    }
}
