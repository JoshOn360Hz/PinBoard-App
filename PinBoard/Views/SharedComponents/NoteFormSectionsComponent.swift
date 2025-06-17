import SwiftUI

struct NoteFormSectionsComponent: View {
    @Binding var title: String
    @Binding var noteBody: String
    @Binding var selectedIcon: String
    @Binding var selectedColor: ColorTheme
    @Binding var selectedFontSize: FontSizeOption
    @Binding var showingIconPicker: Bool
    
    var body: some View {
        Section("Note Content") {
            TextField("Title", text: $title)
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField("Write your note here...", text: $noteBody, axis: .vertical)
                .font(selectedFontSize.font)
                .lineLimit(10...50)
        }
        
        Section("Customization") {
            IconPickerButtonComponent(
                selectedIcon: $selectedIcon,
                showingIconPicker: $showingIconPicker,
                selectedColor: selectedColor
            )
            
            ColorPickerComponent(selectedColor: $selectedColor)
            
            Picker("Text Size", selection: $selectedFontSize) {
                ForEach(FontSizeOption.allCases, id: \.self) { size in
                    Text(size.displayName)
                        .tag(size)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

#Preview {
    Form {
        NoteFormSectionsComponent(
            title: .constant(""),
            noteBody: .constant(""),
            selectedIcon: .constant("note.text"),
            selectedColor: .constant(.blue),
            selectedFontSize: .constant(.medium),
            showingIconPicker: .constant(false)
        )
    }
}
