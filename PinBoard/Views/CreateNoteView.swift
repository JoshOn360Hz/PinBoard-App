import SwiftUI
import CoreData

struct CreateNoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("accentColor") private var accentColor: String = "blue"
    
    @State private var title = ""
    @State private var noteBody = ""
    @State private var selectedIcon = "note.text"
    @State private var selectedColor: ColorTheme = .blue
    @State private var selectedFontSize: FontSizeOption = .medium
    @State private var showingIconPicker = false

    init() {
        let accentColorKey = "accentColor"
        let currentAccent = UserDefaults.standard.string(forKey: accentColorKey) ?? "blue"
        _selectedColor = State(initialValue: ColorTheme(rawValue: currentAccent) ?? .blue)
    }
    
    var body: some View {
        NavigationView {
            NoteFormComponent(
                title: $title,
                noteBody: $noteBody,
                selectedIcon: $selectedIcon,
                selectedColor: $selectedColor,
                selectedFontSize: $selectedFontSize,
                showingIconPicker: $showingIconPicker
            )
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerComponent(selectedIcon: $selectedIcon)
            }
            .accentColor(AppThemeHelper.accentColor(from: accentColor))
        }
    }

    private func saveNote() {
        NoteOperationsHelper.saveNote(
            title: title,
            body: noteBody,
            icon: selectedIcon,
            color: selectedColor,
            fontSize: selectedFontSize,
            to: viewContext
        )
        dismiss()
    }
}

#Preview {
    CreateNoteView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
