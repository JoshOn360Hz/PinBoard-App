import Foundation
import ActivityKit

struct PinBoardWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var noteTitle: String
        var noteBody: String
        var noteIcon: String
        var noteColor: String
        var lastUpdated: Date
    }

    var appName: String = "PinBoard"
}
