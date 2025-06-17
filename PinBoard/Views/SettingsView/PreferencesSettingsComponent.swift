import SwiftUI

struct PreferencesSettingsComponent: View {
    @Binding var defaultFontSize: String
    @Binding var defaultIcon: String
    @Binding var showingIconPicker: Bool
    let accentColor: String
    
    var body: some View {
        Section("Preferences") {
            Picker("Font Size Preference", selection: $defaultFontSize) {
                ForEach(FontSizeOption.allCases, id: \.self) { size in
                    Text(size.displayName).tag(size.rawValue)
                }
            }
            
            HStack {
                Text("Default Icon")
                Spacer()
                Button {
                    showingIconPicker = true
                } label: {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(AppThemeHelper.accentColor(from: accentColor))
                                .frame(width: 32, height: 32)
                                .shadow(radius: 1)
                            
                            Image(systemName: defaultIcon)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        PreferencesSettingsComponent(
            defaultFontSize: .constant("medium"),
            defaultIcon: .constant("note.text"),
            showingIconPicker: .constant(false),
            accentColor: "blue"
        )
    }
}
