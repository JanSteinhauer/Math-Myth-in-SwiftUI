import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            StatBar(
                title: "Stay Wins",
                wins: viewModel.stayWins,
                trials: viewModel.stayTrials,
                color: .blue
            )
            
            Divider()
            
            StatBar(
                title: "Switch Wins",
                wins: viewModel.switchWins,
                trials: viewModel.switchTrials,
                color: .orange
            )
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct StatBar: View {
    let title: String
    let wins: Int
    let trials: Int
    let color: Color
    
    var percentage: Double {
        trials == 0 ? 0 : Double(wins) / Double(trials)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(wins) / \(trials)")
                .font(.headline)
                .monospacedDigit()
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: max(0, geo.size.width * CGFloat(percentage)), height: 8)
                        .animation(.spring(), value: percentage)
                }
            }
            .frame(height: 8)
            
            Text(String(format: "%.1f%%", percentage * 100))
                .font(.caption2)
                .foregroundColor(color)
        }
    }
}
