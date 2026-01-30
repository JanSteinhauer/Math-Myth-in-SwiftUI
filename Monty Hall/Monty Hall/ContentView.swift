import SwiftUI

struct ContentView: View {
    // Top-level State Objects
    @StateObject private var gameVM = GameViewModel()
    @StateObject private var simEngine = SimulationEngine()
    
    // UI State
    @State private var mode: GameMode = .play


    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - TOP ZONE (Story + Controls)
            VStack(spacing: 8) {
                Text("Math Myth #01 — Monty Hall")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
                Text(gameVM.statusMessage)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(height: 60) // Fixed height to prevent jumpiness
                
                // Mode Toggle
                Picker("Mode", selection: $mode) {
                    ForEach(GameMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Button(action: { gameVM.showExplanation = true }) {
                    Text("Explain Logic")
                        .font(.caption)
                        .padding(6)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .sheet(isPresented: $gameVM.showExplanation) {
                    ExplanationSheet()
                }
            }
            .padding(.bottom, 20)
            .background(Color(UIColor.systemBackground))
            .zIndex(1)
            
            Divider()
            
            // MARK: - MIDDLE ZONE (The Doors)
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                if mode == .play {
                    HStack(spacing: 12) {
                        ForEach(gameVM.doors) { door in
                            DoorView(door: door) {
                                gameVM.selectDoor(door.id)
                            }
                        }
                    }
                    .padding()
                } else {
                    // Simulation Mode Visuals
                    VStack {
                        Image(systemName: "cpu")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                            .padding()
                        Text("Simulation Running")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .opacity(simEngine.isRunning ? 1.0 : 0.3)
                    .animation(.easeInOut, value: simEngine.isRunning)
                }
            }
            .frame(maxHeight: .infinity)
            
            Divider()
            
            // MARK: - BOTTOM ZONE (Dashboard)
            VStack(spacing: 20) {
                if mode == .play {
                    ControlPanel(viewModel: gameVM)
                    StatsView(viewModel: gameVM)
                    
                    HStack {
                         Button("Reset Stats") { gameVM.resetStats() }
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                } else {
                    SimulationControlView(simEngine: simEngine)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    ContentView()
}
