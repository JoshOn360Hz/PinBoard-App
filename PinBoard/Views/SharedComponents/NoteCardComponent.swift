import SwiftUI
import CoreData

struct NoteCardComponent: View {
    @ObservedObject var note: Note
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingEditNote = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: note.wrappedIcon)
                    .foregroundColor(note.colorValue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.wrappedTitle)
                        .font(note.fontSizeValue)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(note.wrappedDate, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: togglePin) {
                    Image(systemName: note.isPinned || note.isPinnedToWidget() ? "pin.fill" : "pin")
                        .foregroundColor(note.isPinned || note.isPinnedToWidget() ? .orange : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if !note.wrappedBody.isEmpty {
                Text(note.wrappedBody)
                    .font(note.fontSizeValue)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(note.colorValue, lineWidth: 2)
                )
        )
        .onTapGesture {
            showingEditNote = true
        }
        .sheet(isPresented: $showingEditNote) {
            EditNoteView(note: note)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func togglePin() {
        NoteOperationsHelper.togglePin(for: note, in: viewContext)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let note = Note(context: context)
    note.title = "Sample Note"
    note.body = "This is a sample note body"
    note.icon = "note.text"
    note.color = "blue"
    note.fontSize = "medium"
    note.dateCreated = Date()
    
    return NoteCardComponent(note: note)
        .environment(\.managedObjectContext, context)
        .padding()
}
