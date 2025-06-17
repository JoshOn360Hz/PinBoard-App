import SwiftUI

struct AppearanceSettingsComponent: View {
    @Binding var accentColor: String
    @Binding var colorScheme: String
    let currentAccentColor: Color
    
    private let accentColorOptions: [(name: String, color: Color)] = [
        ("blue", .blue), ("red", .red), ("orange", .orange), ("yellow", .yellow), ("green", .green),
        ("purple", .purple), ("pink", .pink), ("teal", .teal), ("indigo", .indigo), ("mint", .mint)
    ]
    
    var body: some View {
        Section("Appearance") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Accent Color")
                    .font(.headline)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 18) {
                    ForEach(accentColorOptions, id: \.name) { option in
                        Button {
                            accentColor = option.name
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(option.color)
                                    .frame(width: 44, height: 44)
                                    .shadow(radius: 4)
                                
                                if accentColor == option.name {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 18, height: 18)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(option.color)
                                        )
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.vertical, 8)
            
            ColorSchemePickerComponent(
                colorScheme: $colorScheme,
                currentAccentColor: currentAccentColor
            )
            
            NavigationLink(destination: AppIconPickerScreen()) {
                HStack {
                    Image(systemName: "app.fill")
                        .foregroundColor(currentAccentColor)
                        .frame(width: 25)
                    Text("App Icon")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    Form {
        AppearanceSettingsComponent(
            accentColor: .constant("blue"),
            colorScheme: .constant("system"),
            currentAccentColor: .blue
        )
    }
}
