import AppIntents
import SwiftUI
import WidgetKit

struct PinBoardWidgetsControl: ControlWidget {
    static let kind: String = "com.Josh.PinBoard.PinBoardWidgets"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetButton(action: CreateQuickNoteIntent()) {
                Label("Quick Note", systemImage: "plus.square")
            }
        }
        .displayName("Quick Note")
        .description("Quickly create a new note in PinBoard.")
    }
}

extension PinBoardWidgetsControl {
    struct Value {
        var notesCount: Int
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: QuickNoteConfiguration) -> Value {
            PinBoardWidgetsControl.Value(notesCount: 5)
        }

        func currentValue(configuration: QuickNoteConfiguration) async throws -> Value {
            return PinBoardWidgetsControl.Value(notesCount: 0)
        }
    }
}

struct QuickNoteConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Quick Note Configuration"
}

struct CreateQuickNoteIntent: AppIntent {
    static let title: LocalizedStringResource = "Create Quick Note"
    static let description = IntentDescription("Opens PinBoard to create a new note")

    func perform() async throws -> some IntentResult {
   
        return .result()
    }
}
