import Foundation
import SwiftUI
import CoreData

class NoteOperationsHelper {
    static func deleteNotes(_ notes: [Note], from viewContext: NSManagedObjectContext) {
        withAnimation(.spring()) {
            notes.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
            } catch {
                print("Error deleting notes: \(error)")
            }
        }
    }
    
    static func deletePinnedNote(_ note: Note, from viewContext: NSManagedObjectContext) {
        withAnimation(.spring()) {
            if #available(iOS 16.1, *) {
                LiveActivityManager.shared.endLiveActivity()
            }
            note.unpinFromWidget()
            viewContext.delete(note)
            
            do {
                try viewContext.save()
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
            } catch {
                print("Error deleting pinned note: \(error)")
            }
        }
    }
    
    static func togglePin(for note: Note, in viewContext: NSManagedObjectContext) {
        withAnimation(.spring()) {
            do {
                let wasPinned = note.isPinned || note.isPinnedToWidget()
                
                // Unpin all currently pinned notes
                let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "isPinned == YES")
                let pinnedNotes = try viewContext.fetch(fetchRequest)
                for pinnedNote in pinnedNotes {
                    pinnedNote.isPinned = false
                    if pinnedNote.isPinnedToWidget() {
                        pinnedNote.unpinFromWidget()
                    }
                }
                
                if wasPinned {
                    note.isPinned = false
                    note.unpinFromWidget()
                    if #available(iOS 16.1, *) {
                        LiveActivityManager.shared.endLiveActivity()
                    }
                } else {
                    note.isPinned = true
                    note.pinToWidget()
                    if #available(iOS 16.1, *) {
                        LiveActivityManager.shared.startLiveActivity(for: note)
                    }
                }
                
                try viewContext.save()
                let feedback = UIImpactFeedbackGenerator(style: .medium)
                feedback.impactOccurred()
            } catch {
                print("Error toggling pin: \(error)")
            }
        }
    }
    
    static func saveNote(
        title: String,
        body: String,
        icon: String,
        color: ColorTheme,
        fontSize: FontSizeOption,
        to viewContext: NSManagedObjectContext
    ) {
        let newNote = Note(context: viewContext)
        newNote.id = UUID()
        newNote.title = title
        newNote.body = body
        newNote.icon = icon
        newNote.color = color.rawValue
        newNote.fontSize = fontSize.rawValue
        newNote.isPinned = false
        newNote.dateCreated = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    static func updateNote(
        _ note: Note,
        title: String,
        body: String,
        icon: String,
        color: ColorTheme,
        fontSize: FontSizeOption,
        in viewContext: NSManagedObjectContext
    ) {
        note.title = title
        note.body = body
        note.icon = icon
        note.color = color.rawValue
        note.fontSize = fontSize.rawValue
        
        do {
            try viewContext.save()
        } catch {
            print("Error updating note: \(error)")
        }
    }
}

struct HapticFeedbackHelper {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
}

struct SettingsHelper {
    static func iconForScheme(_ scheme: String) -> String {
        switch scheme {
        case "light": return "sun.max.fill"
        case "dark": return "moon.fill"
        default: return "circle.lefthalf.filled"
        }
    }

    static func titleForScheme(_ scheme: String) -> String {
        switch scheme {
        case "light": return "Light"
        case "dark": return "Dark"
        default: return "System"
        }
    }
    
    static func applyColorScheme(_ scheme: String) {
        UIWindow.key?.overrideUserInterfaceStyle = scheme == "light" 
            ? .light 
            : scheme == "dark" 
                ? .dark 
                : .unspecified
    }
}

extension UIWindow {
    static var key: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
