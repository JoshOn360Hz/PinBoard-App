import Foundation
import SwiftUI
import WidgetKit
import WidgetKit
import CoreData

extension Note {
    var wrappedTitle: String {
        title ?? "Untitled"
    }
    
    var wrappedBody: String {
        body ?? ""
    }
    
    var wrappedIcon: String {
        icon ?? "note.text"
    }
    
    var wrappedColor: String {
        color ?? "blue"
    }
    
    var wrappedFontSize: String {
        fontSize ?? "medium"
    }
    
    var wrappedDate: Date {
        dateCreated ?? Date()
    }
    
    var colorValue: Color {
        switch wrappedColor {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "mint": return .mint
        case "teal": return .teal
        case "indigo": return .indigo
        default: return .blue
        }
    }
    
    var fontSizeValue: Font {
        switch wrappedFontSize {
        case "small": return .caption
        case "medium": return .body
        case "large": return .title2
        default: return .body
        }
    }
    
    func pinToWidget() {
        let noteID = self.objectID.uriRepresentation().absoluteString
        
        let pinnedNote = PinnedNote(
            title: self.wrappedTitle,
            body: self.wrappedBody,
            icon: self.wrappedIcon,
            color: self.wrappedColor,
            id: noteID
        )
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.Josh.PinBoard")
        guard let sharedDefaults = sharedDefaults else { return }
        
        var pinnedNotes = [PinnedNote]()
        
        if let pinnedNotesData = sharedDefaults.data(forKey: "pinnedNotes"),
           let existingNotes = try? JSONDecoder().decode([PinnedNote].self, from: pinnedNotesData) {
            let matchingNotes = existingNotes.filter { note in
                if let noteID = note.id, let pinnedID = pinnedNote.id {
                    return noteID == pinnedID
                }
                return note.title == pinnedNote.title && note.body == pinnedNote.body
            }
            
            if matchingNotes.isEmpty {
                pinnedNotes = existingNotes
                pinnedNotes.append(pinnedNote)
            } else {
                pinnedNotes = existingNotes
            }
        } else {
            pinnedNotes = [pinnedNote]
        }
        
        if let pinnedNotesData = try? JSONEncoder().encode(pinnedNotes) {
            sharedDefaults.set(pinnedNotesData, forKey: "pinnedNotes")
            
            if let singleNoteData = try? JSONEncoder().encode(pinnedNote) {
                sharedDefaults.set(singleNoteData, forKey: "pinnedNote")
            }
            
            sharedDefaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func unpinFromWidget() {
        let sharedDefaults = UserDefaults(suiteName: "group.com.Josh.PinBoard")
        guard let sharedDefaults = sharedDefaults else { return }
        
        if #available(iOS 16.1, *) {
            LiveActivityManager.shared.endLiveActivity()
        }
        
        if let pinnedNotesData = sharedDefaults.data(forKey: "pinnedNotes"),
           let existingNotes = try? JSONDecoder().decode([PinnedNote].self, from: pinnedNotesData) {
            
            let filteredNotes = existingNotes.filter { note in
                return note.title != self.wrappedTitle || note.body != self.wrappedBody
            }
            
            if let updatedData = try? JSONEncoder().encode(filteredNotes) {
                sharedDefaults.set(updatedData, forKey: "pinnedNotes")
                
                if let lastNote = filteredNotes.last,
                   let singleData = try? JSONEncoder().encode(lastNote) {
                    sharedDefaults.set(singleData, forKey: "pinnedNote")
                } else {
                    sharedDefaults.removeObject(forKey: "pinnedNote")
                }
                
                sharedDefaults.synchronize()
                
                WidgetCenter.shared.reloadAllTimelines()
            }
        } else {
            sharedDefaults.removeObject(forKey: "pinnedNote")
            sharedDefaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    static func unpinAllFromWidget() {
        let sharedDefaults = UserDefaults(suiteName: "group.com.Josh.PinBoard")
        sharedDefaults?.removeObject(forKey: "pinnedNotes")
        sharedDefaults?.removeObject(forKey: "pinnedNote")
        sharedDefaults?.synchronize()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func isPinnedToWidget() -> Bool {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.Josh.PinBoard") else {
            return false
        }
        
        if let pinnedNotesData = sharedDefaults.data(forKey: "pinnedNotes"),
           let pinnedNotes = try? JSONDecoder().decode([PinnedNote].self, from: pinnedNotesData) {
            
            return pinnedNotes.contains { note in
                if let noteID = note.id {
                    let currentID = self.objectID.uriRepresentation().absoluteString
                    return noteID == currentID
                }
                return note.title == self.wrappedTitle && note.body == self.wrappedBody
            }
        }
          if let pinnedNoteData = sharedDefaults.data(forKey: "pinnedNote"),
           let pinnedNote = try? JSONDecoder().decode(PinnedNote.self, from: pinnedNoteData) {
            return pinnedNote.title == self.wrappedTitle && pinnedNote.body == self.wrappedBody
        }
        
        return false
    }
    
    struct PinnedNote: Codable, Identifiable {
        let title: String
        let body: String
        let icon: String
        let color: String
        let id: String?
    }
}
