import SwiftUI

struct NotePreviewComponent: View {
    let title: String
    let noteBody: String
    let selectedIcon: String
    let selectedColor: ColorTheme
    let selectedFontSize: FontSizeOption
    
    var body: some View {
        Section("Preview") {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: selectedIcon)
                        .foregroundColor(selectedColor.color)
                        .font(.title2)
                    
                    Text(title.isEmpty ? "Note Title" : title)
                        .font(selectedFontSize.font)
                        .fontWeight(.semibold)
                }
                
                if !noteBody.isEmpty {
                    Text(noteBody)
                        .font(selectedFontSize.font)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedColor.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    Form {
        NotePreviewComponent(
            title: "Sample Note",
            noteBody: "This is a sample note body",
            selectedIcon: "star.fill",
            selectedColor: .blue,
            selectedFontSize: .medium
        )
    }
}
