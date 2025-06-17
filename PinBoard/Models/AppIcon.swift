import SwiftUI

struct AppIcon: Identifiable, CaseIterable {
    let id = UUID()
    let name: String
    let displayName: String
    let iconName: String?
    
    static let allCases: [AppIcon] = [
        AppIcon(name: "default", displayName: "Default", iconName: nil),
        AppIcon(name: "icon-purple", displayName: "Purple", iconName: "icon-purple"),
        AppIcon(name: "icon-bubblegum", displayName: "Bubblegum", iconName: "icon-bubblegum"),
        AppIcon(name: "icon-pink", displayName: "Pink", iconName: "icon-pink"),
        AppIcon(name: "icon-green", displayName: "Green", iconName: "icon-green"),
        AppIcon(name: "icon-darkred", displayName: "Dark Red", iconName: "icon-darkred"),
        AppIcon(name: "icon-dark", displayName: "Dark", iconName: "icon-dark"),
        AppIcon(name: "icon-dark-bubblegum", displayName: "Dark Bubblegum", iconName: "icon-dark-bubblegum"),
        AppIcon(name: "icon-dark-blue", displayName: "Dark Blue", iconName: "icon-dark-blue"),
        AppIcon(name: "icon-dark-purple", displayName: "Dark Purple", iconName: "icon-dark-purple"),
        AppIcon(name: "icon-dark-green", displayName: "Dark Green", iconName: "icon-dark-green"),
        AppIcon(name: "icon-dark-darkred", displayName: "Dark Dark Red", iconName: "icon-dark-darkred")
    ]
}
