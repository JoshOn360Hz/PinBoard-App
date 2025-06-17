import SwiftUI
import CoreData

struct EditNoteView: View {
    let note: Note
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("accentColor") private var accentColor = "blue"
    
    @State private var title: String
    @State private var noteBody: String
    @State private var selectedIcon: String
    @State private var selectedColor: ColorTheme
    @State private var selectedFontSize: FontSizeOption
    @State private var showingIconPicker = false
    @State private var showingDeleteAlert = false
    @State private var isPinnedToWidget = false
    
    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.wrappedTitle)
        _noteBody = State(initialValue: note.wrappedBody)
        _selectedIcon = State(initialValue: note.wrappedIcon)
        _selectedColor = State(initialValue: ColorTheme(rawValue: note.wrappedColor) ?? .blue)
        _selectedFontSize = State(initialValue: FontSizeOption(rawValue: note.wrappedFontSize) ?? .medium)
        _isPinnedToWidget = State(initialValue: note.isPinnedToWidget())
    }
    
    var body: some View {
        NavigationView {
            Form {
                NoteFormSectionsComponent(
                    title: $title,
                    noteBody: $noteBody,
                    selectedIcon: $selectedIcon,
                    selectedColor: $selectedColor,
                    selectedFontSize: $selectedFontSize,
                    showingIconPicker: $showingIconPicker
                )
                
                NoteActionsComponent(
                    note: note,
                    isPinnedToWidget: isPinnedToWidget,
                    onTogglePin: togglePin,
                    onDelete: { showingDeleteAlert = true }
                )
            }
            .navigationTitle("Edit Note")
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
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerComponent(selectedIcon: $selectedIcon)
            }
            .alert("Delete Note", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    deleteNote()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this note? This action cannot be undone.")
            }
            .onAppear {
                isPinnedToWidget = note.isPinnedToWidget()
            }
            .accentColor(AppThemeHelper.accentColor(from: accentColor))
        }
    }
    
    private func saveNote() {
        NoteOperationsHelper.updateNote(
            note,
            title: title,
            body: noteBody,
            icon: selectedIcon,
            color: selectedColor,
            fontSize: selectedFontSize,
            in: viewContext
        )
        
        if isPinnedToWidget {
            note.pinToWidget()
        }
        
        if note.isPinned, #available(iOS 16.1, *) {
            LiveActivityManager.shared.updateLiveActivity(for: note)
        }
        
        dismiss()
    }
    
    private func togglePin() {
        NoteOperationsHelper.togglePin(for: note, in: viewContext)
        isPinnedToWidget = note.isPinnedToWidget()
    }
    
    private func deleteNote() {
        viewContext.delete(note)
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error deleting note: \(error)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleNote = Note(context: context)
    sampleNote.title = "Sample Note"
    sampleNote.body = "This is a sample note for preview"
    sampleNote.icon = "star.fill"
    sampleNote.color = "blue"
    sampleNote.fontSize = "medium"
    
    return EditNoteView(note: sampleNote)
        .environment(\.managedObjectContext, context)
}
