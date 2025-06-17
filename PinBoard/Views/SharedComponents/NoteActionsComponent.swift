import SwiftUI
import CoreData

struct NoteActionsComponent: View {
    let note: Note
    let isPinnedToWidget: Bool
    let onTogglePin: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Section("Actions") {
            Button(action: onTogglePin) {
                HStack {
                    Image(systemName: note.isPinned || isPinnedToWidget ? "pin.fill" : "pin")
                        .foregroundColor(note.isPinned || isPinnedToWidget ? .orange : .gray)
                    Text(note.isPinned || isPinnedToWidget ? "Unpin Note" : "Pin Note")
                        .foregroundColor(note.isPinned || isPinnedToWidget ? .orange : .primary)
                }
            }
            
            Button("Delete Note", role: .destructive) {
                onDelete()
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let note = Note(context: context)
    note.title = "Sample Note"
    note.isPinned = false
    
    return Form {
        NoteActionsComponent(
            note: note,
            isPinnedToWidget: false,
            onTogglePin: {},
            onDelete: {}
        )
    }
}
