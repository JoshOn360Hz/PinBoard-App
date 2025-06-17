import ActivityKit
import WidgetKit
import SwiftUI


private enum ColorTheme: String, CaseIterable {
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

private func colorFromString(_ colorString: String) -> Color {
    return ColorTheme(rawValue: colorString)?.color ?? .blue
}

struct PinBoardWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PinBoardWidgetsAttributes.self) { context in
            HStack(spacing: 12) {
                Image(systemName: context.state.noteIcon)
                    .font(.title2)
                    .foregroundColor(colorFromString(context.state.noteColor))

                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.noteTitle)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    if !context.state.noteBody.isEmpty {
                        Text(context.state.noteBody)
                            .font(.body)
                            .lineLimit(2)
                            .foregroundColor(colorFromString(context.state.noteColor))
                    }
                }

                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .activityBackgroundTint(.clear)
            .activitySystemActionForegroundColor(.primary)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        // left icon
                        Image(systemName: context.state.noteIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(colorFromString(context.state.noteColor))
                            .padding(.top, -8)

                        Spacer()

                        //  text
                        VStack(spacing: 4) {
                            Text(context.state.noteTitle)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .padding(.top, 10)

                            if !context.state.noteBody.isEmpty {
                                Text(context.state.noteBody)
                                    .font(.subheadline)
                                    .foregroundColor(colorFromString(context.state.noteColor))                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                        // Right icon
                        Image(systemName: "pin.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                           .foregroundColor(colorFromString(context.state.noteColor))
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal)
                    .padding(.top, -8)
                }

                DynamicIslandExpandedRegion(.leading) { EmptyView() }
                DynamicIslandExpandedRegion(.trailing) { EmptyView() }

            } compactLeading: {
                Image(systemName: context.state.noteIcon)
                    .font(.caption)
                    .foregroundColor(colorFromString(context.state.noteColor))
            } compactTrailing: {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .foregroundColor(colorFromString(context.state.noteColor))
            } minimal: {
                Image(systemName: context.state.noteIcon)
                    .font(.caption)
                    .foregroundColor(colorFromString(context.state.noteColor))
            }
            .widgetURL(URL(string: "pinboard://openNote"))
            .keylineTint(colorFromString(context.state.noteColor))
        }
    }
}


extension PinBoardWidgetsAttributes {
    fileprivate static var preview: PinBoardWidgetsAttributes {
        PinBoardWidgetsAttributes(appName: "PinBoard")
    }
}


