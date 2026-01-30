import Foundation
import Combine

class SimulationEngine: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var progress: Double = 0.0 // 0.0 to 1.0
    @Published var totalRunsRequested: Int = 100
    @Published var currentRunCount: Int = 0
    
    // Results
    @Published var stayWins: Int = 0
    @Published var switchWins: Int = 0
    
    // Configuration
    @Published var strategy: SimulationStrategy = .alwaysSwitch
    
    private var task: Task<Void, Never>?
    
    func toggleSimulation(runs: Int) {
        if isRunning {
            stop()
        } else {
            totalRunsRequested = runs
            run()
        }
    }
    
    func stop() {
        task?.cancel()
        isRunning = false
    }
    
    func reset() {
        stop()
        stayWins = 0
        switchWins = 0
        currentRunCount = 0
        progress = 0
    }
    
    private func run() {
        reset()
        isRunning = true
        
        task = Task.detached(priority: .userInitiated) {
            for i in 1...self.totalRunsRequested {
                if Task.isCancelled { break }
                
                let result = self.simulateSingleGame(strategy: self.strategy)
                
                await MainActor.run {
                    if result.didSwitch {
                        self.switchWins += result.didWin ? 1 : 0
                    } else {
                        self.stayWins += result.didWin ? 1 : 0
                    }
                    
                    self.currentRunCount = i
                    self.progress = Double(i) / Double(self.totalRunsRequested)
                }
                
                // Yield occasionally to keep UI responsive if batching heavy
                if i % 100 == 0 {
                    try? await Task.sleep(nanoseconds: 1_000_000) // 1ms
                }
            }
            
            await MainActor.run {
                self.isRunning = false
            }
        }
    }
    
    private func simulateSingleGame(strategy: SimulationStrategy) -> (didWin: Bool, didSwitch: Bool) {
        // FAST LOGIC - No overhead
        let carIndex = Int.random(in: 0..<3)
        let playerInitialPick = Int.random(in: 0..<3)
        
        // Host reveals a goat...
        
        // Strategy Decide
        var didSwitch = false
        var playerWins = false
        
        if strategy == .alwaysSwitch {
             didSwitch = true
             // If I picked car initially (1/3), I switch to a Goat -> LOSE
             // If I picked goat initially (2/3), I switch to the Car -> WIN
             playerWins = (playerInitialPick != carIndex)
            
        } else if strategy == .alwaysStay {
            didSwitch = false
            // Stay means: I win if I picked car initially
            playerWins = (playerInitialPick == carIndex)
            
        } else {
            // Random strategy: 50/50 switch or stay
            didSwitch = Bool.random()
            if didSwitch {
                playerWins = (playerInitialPick != carIndex)
            } else {
                playerWins = (playerInitialPick == carIndex)
            }
        }
        
        return (playerWins, didSwitch)
    }
}
