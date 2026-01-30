import SwiftUI

struct ExplanationSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            TabView {
                ExplanationTab(
                    title: "Intuition",
                    content: "It feels 50/50 because two doors remain... but the host’s action is not random. The host knows where the car is and MUST reveal a goat. This adds information to the system."
                )
                .tabItem { Label("Intuition", systemImage: "brain.head.profile") }
                
                ExplanationTab(
                    title: "The Key Rule",
                    content: "1. Your first pick has a 1/3 chance to be the car.\n\n2. The other two doors TOGETHER have a 2/3 chance.\n\n3. When the host opens a goat door, he doesn't change your first pick's probability.\n\n4. Therefore, the 2/3 probability concentrates on the ONLY other unopened door."
                )
                .tabItem { Label("Rules", systemImage: "list.bullet") }
                
                ExplanationTab(
                    title: "Proof by Cases",
                    content: "Case 1: You picked Car (1/3)\n→ Host reveals Goat\n→ Switch loses.\n\nCase 2: You picked Goat A (1/3)\n→ Host reveals Goat B\n→ Switch WINS.\n\nCase 3: You picked Goat B (1/3)\n→ Host reveals Goat A\n→ Switch WINS.\n\nConclusion: Switching wins 2 out of 3 times!"
                )
                .tabItem { Label("Proof", systemImage: "checkmark.seal") }
            }
            .navigationTitle("Why Switch?")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}

struct ExplanationTab: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .bold()
                
                Text(content)
                    .font(.body)
                    .lineSpacing(4)
                
                Spacer()
            }
            .padding()
        }
    }
}
