import SwiftUI

struct AboutSettingsComponent: View {
    var body: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0").foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    Form {
        AboutSettingsComponent()
    }
}
