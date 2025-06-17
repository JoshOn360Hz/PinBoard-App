import WidgetKit
import SwiftUI

@main
struct PinBoardWidgetsBundle: WidgetBundle {
    var body: some Widget {
        PinBoardWidgets()
        PinBoardWidgetsControl()
        PinBoardWidgetsLiveActivity()
    }
}
