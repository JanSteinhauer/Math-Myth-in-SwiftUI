import SwiftUI

struct ControlPanel: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            switch viewModel.phase {
            case .choose:
                Text("Select a door above to start.")
                    .foregroundColor(.secondary)
                    .padding()
            
            case .reveal:
                // Auto-transition usually, but if manual:
                Text("Host revealing...")
                    .foregroundColor(.secondary)
            
            case .decide:
                HStack(spacing: 20) {
                    Button(action: { viewModel.decide(switchDoor: false) }) {
                        Text("Stay")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { viewModel.decide(switchDoor: true) }) {
                        Text("Switch")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
            case .result:
                Button(action: { viewModel.startNewGame() }) {
                    Text("Play Again")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
    }
}
