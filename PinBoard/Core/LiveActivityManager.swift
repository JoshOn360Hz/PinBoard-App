import Foundation
import ActivityKit
import CoreData
import Combine
import SwiftUI

@available(iOS 16.1, *)
class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<PinBoardWidgetsAttributes>?
    @AppStorage("enableLiveActivity") private var enableLiveActivity = true
    
    private init() {}
    
    func startLiveActivity(for note: Note) {
        guard enableLiveActivity else {
            print("Live Activity is disabled in settings")
            return
        }
        
        endLiveActivity()
        
        let attributes = PinBoardWidgetsAttributes(appName: "PinBoard")
        let contentState = PinBoardWidgetsAttributes.ContentState(
            noteTitle: note.wrappedTitle,
            noteBody: note.wrappedBody,
            noteIcon: note.wrappedIcon,
            noteColor: note.wrappedColor,
            lastUpdated: Date()
        )
        let content = ActivityContent(state: contentState, staleDate: nil)
        do {
            currentActivity = try Activity<PinBoardWidgetsAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            print("Live Activity started for note: \(note.wrappedTitle)")
        } catch {
            print("Error starting Live Activity: \(error)")
        }
    }
    
    func updateLiveActivity(for note: Note) {
        guard enableLiveActivity else {
            endLiveActivity()
            return
        }
        
        guard let activity = currentActivity else {
            startLiveActivity(for: note)
            return
        }
        
        let contentState = PinBoardWidgetsAttributes.ContentState(
            noteTitle: note.wrappedTitle,
            noteBody: note.wrappedBody,
            noteIcon: note.wrappedIcon,
            noteColor: note.wrappedColor,
            lastUpdated: Date()
        )
        
        Task {
            await activity.update(using: contentState)
            print("Live Activity updated for note: \(note.wrappedTitle)")
        }
    }
    
    func endLiveActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            let finalContentState = activity.content.state
            await activity.end(using: finalContentState, dismissalPolicy: .immediate)
            currentActivity = nil
            print("Live Activity ended")
        }
    }
    
    var isActivityActive: Bool {
        return currentActivity != nil
    }
}

