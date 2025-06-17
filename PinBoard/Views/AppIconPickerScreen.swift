import SwiftUI

struct AppIconPickerScreen: View {
    @AppStorage("selectedAppIcon") private var selectedAppIcon = "default"
    @AppStorage("accentColor") private var accentColor = "blue"

    let icons = AppIcon.allCases
    let columns = [GridItem(.adaptive(minimum: 110), spacing: 16)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(icons) { icon in
                    Button {
                        select(icon)
                    } label: {
                        VStack(spacing: 8) {
                            let imageName = icon.iconName ?? "icon-default"
                            if let image = UIImage(named: imageName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 72, height: 72)
                                    .cornerRadius(16)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 72, height: 72)
                            }

                            Text(icon.displayName)
                                .font(.caption2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(selectedAppIcon == icon.name ? ColorTheme(rawValue: accentColor)?.color ?? .blue : Color.clear, lineWidth: 2.5)
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
                        )
                        
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("App Icon")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func select(_ icon: AppIcon) {
        selectedAppIcon = icon.name
        setAlternateIcon(to: icon.iconName)

#if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
    }

    private func setAlternateIcon(to name: String?) {
#if canImport(UIKit)
        guard UIApplication.shared.supportsAlternateIcons else { return }
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print("Icon change error: \(error.localizedDescription)")
            }
        }
#endif
    }
}

