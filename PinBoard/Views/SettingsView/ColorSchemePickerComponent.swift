import SwiftUI

struct ColorSchemePickerComponent: View {
    @Binding var colorScheme: String
    let currentAccentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Scheme")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                
                GeometryReader { geometry in
                    let segmentWidth = geometry.size.width / CGFloat(3)
                    let selectedIndex = colorScheme == "light" ? 1 : (colorScheme == "dark" ? 2 : 0)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(currentAccentColor)
                        .frame(width: segmentWidth - 8) 
                        .padding(4)
                        .offset(x: CGFloat(selectedIndex) * segmentWidth)
                        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: colorScheme)
                }
                
                HStack(spacing: 0) {
                    ForEach(["system", "light", "dark"], id: \.self) { scheme in
                        Button(action: {
                            colorScheme = scheme
                            SettingsHelper.applyColorScheme(scheme)
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: SettingsHelper.iconForScheme(scheme))
                                    .font(.system(size: 22))
                                    .foregroundColor(colorScheme == scheme ? .white : .secondary)
                                
                                Text(SettingsHelper.titleForScheme(scheme))
                                    .font(.caption)
                                    .fontWeight(colorScheme == scheme ? .semibold : .regular)
                                    .foregroundColor(colorScheme == scheme ? .white : .primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(height: 80)
        }
    }
}

#Preview {
    ColorSchemePickerComponent(
        colorScheme: .constant("system"),
        currentAccentColor: .blue
    )
    .padding()
}
