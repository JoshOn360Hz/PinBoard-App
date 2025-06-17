import SwiftUI
import CoreData
import WidgetKit

@main
struct PinBoardApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("colorScheme") private var colorScheme = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(getPreferredColorScheme())
                .onOpenURL { _ in
                    // Just reload widget timelines when app opened
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
    }
    
    func getPreferredColorScheme() -> ColorScheme? {
        return AppThemeHelper.getColorScheme(from: colorScheme)
    }
}
