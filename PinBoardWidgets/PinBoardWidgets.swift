import WidgetKit
import SwiftUI
import AppIntents

@available(iOS 17.0, *)
struct OpenPinBoardAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Open PinBoard"
    static var description: IntentDescription = "Opens the PinBoard app."
    
    @MainActor
    func perform() async throws -> some IntentResult {
       
        return .result()
    }
}

@available(iOS 17.0, *)
struct CreateNewNoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Create New Note"
    static var description: IntentDescription = "Creates a new note in PinBoard."
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "PinBoard Note" }
    static var description: IntentDescription { "View your pinned note at a glance" }
    
    @Parameter(title: "Note Display", default: .latest)
    var noteDisplay: NoteDisplayOption
        static var openAppWhenRun: Bool { true }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            pinnedNote: PinnedNote(
                title: "Sample Note", 
                body: "This is a sample pinned note", 
                icon: "star.fill", 
                color: "blue",
                id: "sample-id"
            )
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: configuration,
            pinnedNote: PinnedNote(
                title: "Meeting Notes", 
                body: "Discuss project timeline and resources", 
                icon: "calendar", 
                color: "purple",
                id: "preview-id"
            )
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let pinnedNote = getPinnedNote(displayOption: configuration.noteDisplay)
        
        let entry = SimpleEntry(date: currentDate, configuration: configuration, pinnedNote: pinnedNote)
        entries.append(entry)
        
        return Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!))
    }
    
    private func getPinnedNote(displayOption: NoteDisplayOption = .latest) -> PinnedNote? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.Josh.PinBoard")
        
        guard let sharedDefaults = sharedDefaults else {
            return nil
        }
        
        if let pinnedNotesData = sharedDefaults.data(forKey: "pinnedNotes"),
           let pinnedNotes = try? JSONDecoder().decode([PinnedNote].self, from: pinnedNotesData),
           !pinnedNotes.isEmpty {
            
            switch displayOption {
            case .latest:
                return pinnedNotes.last
            case .oldest:
                return pinnedNotes.first
            }
        }
        
        if let pinnedNoteData = sharedDefaults.data(forKey: "pinnedNote"),
           let pinnedNote = try? JSONDecoder().decode(PinnedNote.self, from: pinnedNoteData) {
            return pinnedNote
        }
        
        return nil
    }
}

enum NoteDisplayOption: String, AppEnum {
    case latest = "Latest"
    case oldest = "Oldest"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Note Display"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .latest: "Latest Pinned Note",
        .oldest: "First Pinned Note"
    ]
}

struct PinnedNote: Codable {
    let title: String
    let body: String
    let icon: String
    let color: String
    let id: String?
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let pinnedNote: PinnedNote?
}

struct PinBoardWidgetsEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let pinnedNote = entry.pinnedNote {
            Group {
                switch widgetFamily {
                case .systemMedium:
                    mediumWidget(pinnedNote: pinnedNote)
                default:
                    smallWidget(pinnedNote: pinnedNote)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else {
            VStack(spacing: 10) {
                Image(systemName: "pin.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
                    .symbolRenderingMode(.multicolor)
                
                Text("Pin your first note")
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                
                Text("Open PinBoard to pin a note")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func smallWidget(pinnedNote: PinnedNote) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: pinnedNote.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(colorFromString(pinnedNote.color))
                    .frame(width: 26, height: 26)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(colorFromString(pinnedNote.color).opacity(0.1))
                    )
                
                Text(pinnedNote.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(.primary)
            }
            
            Text(pinnedNote.body)
                .font(.system(size: 13))
                .lineLimit(3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
        }
    }
    
    private func mediumWidget(pinnedNote: PinnedNote) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Image(systemName: pinnedNote.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(colorFromString(pinnedNote.color))
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorFromString(pinnedNote.color).opacity(0.1))
                    )
            }
            .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(pinnedNote.title)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                
                Text(pinnedNote.body)
                    .font(.system(size: 14))
                    .lineLimit(5)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    private func colorFromString(_ colorString: String) -> Color {
        let accentColor = UserDefaults.standard.string(forKey: "accentColor") ?? "blue"

        switch colorString {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "teal": return .teal
        case "indigo": return .indigo
        case "mint": return .mint
        default: 
           
            return colorFromAccentString(accentColor)
        }
    }
    
    private func colorFromAccentString(_ accentString: String) -> Color {
        switch accentString {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "teal": return .teal
        case "indigo": return .indigo
        case "mint": return .mint
        default: return .blue
        }
    }
}

struct PinBoardWidgets: Widget {
    let kind: String = "PinBoardWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PinBoardWidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "pinboard://"))
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("PinBoard Note")
        .description("View your pinned note at a glance.")
    }
}


extension ConfigurationAppIntent {
    fileprivate static var standard: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.noteDisplay = .latest
        return intent
    }
    
    fileprivate static var oldest: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.noteDisplay = .oldest
        return intent
    }
}

#Preview(as: .systemSmall) {
    PinBoardWidgets()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: .standard,
        pinnedNote: PinnedNote(
            title: "Meeting with John",
            body: "Discuss project timeline and design revisions for the new app",
            icon: "calendar",
            color: "purple",
            id: "preview-id-1"
        )
    )
    
    SimpleEntry(
        date: .now,
        configuration: .standard,
        pinnedNote: nil
    )
}

#Preview(as: .systemMedium) {
    PinBoardWidgets()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: .standard,
        pinnedNote: PinnedNote(
            title: "Project Deadline",
            body: "Complete the wireframes by Friday and share with the team. Make sure to include feedback from last meeting and update the color scheme based on brand guidelines.",
            icon: "clock.fill",
            color: "red",
            id: "preview-id-2"
        )
    )
}
