//
//  LiveActivityManager.swift
//  PinBoard
//
//  Created by Josh Mansfield on 17/06/2025.
//

import Foundation
import ActivityKit
import CoreData
import Combine

@available(iOS 16.1, *)
class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<PinBoardWidgetsAttributes>?
    
    private init() {}
    
    func startLiveActivity(for note: Note) {
        // End any existing activity first
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
        guard let activity = currentActivity else {
            // If no activity exists, start a new one
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

