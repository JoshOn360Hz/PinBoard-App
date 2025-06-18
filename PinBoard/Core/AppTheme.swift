import SwiftUI

enum FontSizeOption: String, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    
    var displayName: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .caption
        case .medium: return .body
        case .large: return .title2
        }
    }
}

enum ColorTheme: String, CaseIterable {
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case purple = "purple"
    case pink = "pink"
    case mint = "mint"
    case indigo = "indigo"
    case teal = "teal"
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .mint: return .mint
        case .indigo: return .indigo
        case .teal: return .teal
        }
    }
}

struct AppThemeHelper {
    static func getColorScheme(from string: String) -> ColorScheme? {
        switch string {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil 
        }
    }
    
    static func accentColor(from string: String) -> Color {
        return ColorTheme(rawValue: string)?.color ?? .blue
    }
}
