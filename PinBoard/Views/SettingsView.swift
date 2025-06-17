import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("accentColor") private var accentColor = "blue"
    @AppStorage("defaultFontSize") private var defaultFontSize = "medium"
    @AppStorage("defaultIcon") private var defaultIcon = "note.text"
    @AppStorage("selectedAppIcon") private var selectedAppIcon = "default"
    @AppStorage("colorScheme") private var colorScheme = "system"

    @State private var showingIconPicker = false
    @State private var showingAppIconPicker = false

    private var currentAccentColor: Color {
        AppThemeHelper.accentColor(from: accentColor)
    }

    var body: some View {
        NavigationView {
            List {
                AppearanceSettingsComponent(
                    accentColor: $accentColor,
                    colorScheme: $colorScheme,
                    currentAccentColor: currentAccentColor
                )
                
                PreferencesSettingsComponent(
                    defaultFontSize: $defaultFontSize,
                    defaultIcon: $defaultIcon,
                    showingIconPicker: $showingIconPicker,
                    accentColor: accentColor
                )

                AboutSettingsComponent()
            }
            .navigationTitle("Settings")
            .accentColor(currentAccentColor)
            .sheet(isPresented: $showingIconPicker) {
                IconPickerComponent(selectedIcon: $defaultIcon)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
