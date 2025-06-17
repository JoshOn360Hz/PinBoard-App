import SwiftUI

struct ColorPickerComponent: View {
    @Binding var selectedColor: ColorTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 18) {
                ForEach(ColorTheme.allCases, id: \.self) { colorTheme in
                    Button {
                        selectedColor = colorTheme
                        HapticFeedbackHelper.light()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorTheme.color)
                                .frame(width: 44, height: 44)
                                .shadow(radius: 2)
                            
                            if selectedColor == colorTheme {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(colorTheme.color)
                                    )
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ColorPickerComponent(selectedColor: .constant(.blue))
}
