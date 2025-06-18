import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("accentColor") private var accentColor = "blue"
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    
    var body: some View {
        TabView {
            NoteListView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(AppThemeHelper.accentColor(from: accentColor))
        .environment(\.horizontalSizeClass, .compact)
        .onAppear {
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingSplashView(showOnboarding: $showOnboarding)
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
