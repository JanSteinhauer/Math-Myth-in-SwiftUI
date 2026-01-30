import SwiftUI

struct SimulationControlView: View {
    @ObservedObject var simEngine: SimulationEngine
    
    var body: some View {
        VStack(spacing: 16) {
            // Strategy Picker
            Picker("Strategy", selection: $simEngine.strategy) {
                ForEach(SimulationStrategy.allCases) { strategy in
                    Text(strategy.rawValue).tag(strategy)
                }
            }
            .pickerStyle(.segmented)
            
            // Runs
            HStack {
                Button("Run 100") { simEngine.toggleSimulation(runs: 100) }
                Button("Run 1k") { simEngine.toggleSimulation(runs: 1000) }
                Button("Run 10k") { simEngine.toggleSimulation(runs: 10000) }
            }
            .buttonStyle(.bordered)
            .disabled(simEngine.isRunning)
            
            // Progress
            if simEngine.isRunning {
                VStack {
                    ProgressView(value: simEngine.progress)
                    Text("Running... \(simEngine.currentRunCount) / \(simEngine.totalRunsRequested)")
                        .font(.caption)
                        .monospacedDigit()
                }
            }
            
            // Results
            HStack(spacing: 40) {
                VStack {
                    Text("Stay Wins")
                    Text("\(simEngine.stayWins)")
                        .font(.title2)
                        .bold()
                }
                
                VStack {
                    Text("Switch Wins")
                    Text("\(simEngine.switchWins)")
                        .font(.title2)
                        .bold()
                }
            }
            
            if !simEngine.isRunning && simEngine.currentRunCount > 0 {
                Text("Switch win rate: \(String(format: "%.1f", (Double(simEngine.switchWins)/Double(simEngine.currentRunCount))*100))%")
                    .font(.footnote)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
