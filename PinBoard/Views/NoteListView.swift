import SwiftUI
import CoreData

struct NoteListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("accentColor") private var accentColor = "blue"
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.dateCreated, ascending: false)],
        animation: .default)
    private var notes: FetchedResults<Note>
    
    @State private var showingCreateNote = false
    @State private var shouldCreateNote = false

    var pinnedNote: Note? {
        notes.first { $0.isPinned }
    }
    
    var unpinnedNotes: [Note] {
        notes.filter { !$0.isPinned }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        let notesToDelete = offsets.map { unpinnedNotes[$0] }
        NoteOperationsHelper.deleteNotes(notesToDelete, from: viewContext)
    }
    
    private func deletePinnedNote() {
        guard let pinned = pinnedNote else { return }
        NoteOperationsHelper.deletePinnedNote(pinned, from: viewContext)
    }

    var body: some View {
        NavigationView {
            Group {
                if notes.isEmpty {
                    EmptyStateView(onAddTap: { showingCreateNote = true })
                } else {
                    List {
                        if let pinned = pinnedNote {
                            Section {
                                NoteCardComponent(note: pinned)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            deletePinnedNote()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            } header: {
                                HStack {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(.orange)
                                    Text("Pinned Note")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        Section {
                            ForEach(unpinnedNotes, id: \.objectID) { note in
                                NoteCardComponent(note: note)
                            }
                            .onDelete(perform: deleteNotes)
                        } header: {
                            HStack {
                                Text("All Notes")
                                Spacer()
                                Text("\(notes.count)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("PinBoard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateNote) {
                CreateNoteView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .onChange(of: shouldCreateNote) { newValue in
                if newValue {
                    showingCreateNote = true
                    shouldCreateNote = false
                }
            }
            .accentColor(AppThemeHelper.accentColor(from: accentColor))
        }
    }
}

struct EmptyStateView: View {
    var onAddTap: () -> Void
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text.badge.plus")
                .font(.system(size: 70))
                .foregroundColor(AppThemeHelper.accentColor(from: accentColor))
            
            Text("No Notes")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Tap the button below to create your first note")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onAddTap) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Note")
                }
                .padding()
                .foregroundColor(.white)
                .background(AppThemeHelper.accentColor(from: accentColor))
                .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    NoteListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
