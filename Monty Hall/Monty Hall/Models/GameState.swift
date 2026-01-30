import Foundation

enum GamePhase: Equatable {
    case choose     // Waiting for user to pick a door
    case reveal     // Host reveals a goat
    case decide     // User chooses to Stay or Switch
    case result     // Outcome shown
}

enum GameMode: String, CaseIterable, Identifiable {
    case play = "Play"
    case simulate = "Simulate"
    
    var id: String { self.rawValue }
}

enum SimulationStrategy: String, CaseIterable, Identifiable {
    case alwaysStay = "Always Stay"
    case alwaysSwitch = "Always Switch"
    case random = "Random"
    
    var id: String { self.rawValue }
}
