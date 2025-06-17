import SwiftUI

struct IconPickerComponent: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @AppStorage("accentColor") private var accentColor = "blue"
    
    var accentColorValue: Color {
        AppThemeHelper.accentColor(from: accentColor)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(IconDataProvider.iconCategories, id: \.name) { category in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.name)
                                .font(.headline)
                                .padding(.leading, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 60), spacing: 16), count: 5), spacing: 16) {
                                ForEach(category.icons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                        HapticFeedbackHelper.medium()
                                    }) {
                                        VStack {
                                            Image(systemName: icon)
                                                .font(.system(size: 26))
                                                .frame(width: 54, height: 54)
                                                .foregroundColor(selectedIcon == icon ? .white : .primary)
                                                .background(
                                                    Circle()
                                                        .fill(selectedIcon == icon ? accentColorValue : Color.secondary.opacity(0.1))
                                                )
                                                
                                            Text(icon.components(separatedBy: ".").first ?? icon)
                                                .font(.system(size: 10))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct IconPickerButtonComponent: View {
    @Binding var selectedIcon: String
    @Binding var showingIconPicker: Bool
    let selectedColor: ColorTheme
    
    var body: some View {
        HStack {
            Text("Icon")
            Spacer()
            Button(action: { showingIconPicker = true }) {
                ZStack {
                    Circle()
                        .fill(selectedColor.color)
                        .frame(width: 32, height: 32)
                        .shadow(radius: 1)
                    
                    Image(systemName: selectedIcon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    IconPickerComponent(selectedIcon: .constant("note.text"))
}
