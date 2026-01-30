import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // MARK: - Game State
    @Published var doors: [Door] = []
    @Published var phase: GamePhase = .choose
    @Published var selectedDoorId: Int? = nil
    @Published var finalResult: Bool? = nil // true = win, false = loss
    @Published var showExplanation: Bool = false
    
    // Stats
    @Published var stayWins: Int = 0
    @Published var stayTrials: Int = 0
    @Published var switchWins: Int = 0
    @Published var switchTrials: Int = 0
    
    // Derived
    var statusMessage: String {
        switch phase {
        case .choose: return "Pick a door."
        case .reveal: return "Host reveals a goat."
        case .decide: return "Now: stay or switch?"
        case .result: 
            guard let result = finalResult else { return "Game Over" }
            return result ? "You WON! 🚗" : "You LOST! 🐐"
        }
    }

    
    
    init() {
        startNewGame()
    }
    
    // MARK: - Game Logic
    
    func startNewGame() {
        // Reset state
        phase = .choose
        selectedDoorId = nil
        finalResult = nil
        
        // Randomize prize
        let carIndex = Int.random(in: 0..<3)
        doors = (0..<3).map { index in
            Door(
                id: index,
                content: index == carIndex ? .car : .goat,
                state: .closed
            )
        }
    }
    
    func selectDoor(_ id: Int) {
        guard phase == .choose else { return }
        
        selectedDoorId = id
        
        // Update door states
        for index in doors.indices {
            if doors[index].id == id {
                doors[index].state = .selected
            } else {
                doors[index].state = .closed
            }
        }
        
        // Auto-advance to reveal after short delay (can be handled by view or here, let's just transition logic)
        // We'll call reveal logic manually from the View to allow animation timing if needed,
        // or just execute it immediately. Let's execute immediately for the logic, View adds processing delay.
        revealGoat()
    }
    
    private func revealGoat() {
        phase = .reveal
        
        // Host reveals a goat from unselected doors
        let availableDoors = doors.filter { $0.id != selectedDoorId }
        
        // Host MUST reveal a goat.
        // If player picked Car, both others are goats -> pick random one
        // If player picked Goat, only one other is goat -> pick that one
        
        let goatDoors = availableDoors.filter { $0.content == .goat }
        guard let doorToReveal = goatDoors.randomElement() else { return }
        
        // Update state
        if let index = doors.firstIndex(where: { $0.id == doorToReveal.id }) {
            doors[index].state = .revealed
        }
        
        // Transition to Decide phase
        // In a real app we might want a delay here so the user sees "Host revealing...", 
        // but for now we set the state and let the View handle the "Next" button or auto-transition.
        // The prompt says: "Host reveals... now stay or switch". 
        phase = .decide
    }
    
    func decide(switchDoor: Bool) {
        guard phase == .decide, let initialPickId = selectedDoorId else { return }
        
        var finalPickId = initialPickId
        
        if switchDoor {
            // Find the door that is NOT the initial pick AND NOT revealed
            if let newDoor = doors.first(where: { $0.id != initialPickId && $0.state != .revealed }) {
                finalPickId = newDoor.id
            }
            switchTrials += 1
        } else {
            stayTrials += 1
        }
        
        // Result
        if let index = doors.firstIndex(where: { $0.id == finalPickId }) {
            let won = doors[index].content == .car
            finalResult = won
            
            if switchDoor && won { switchWins += 1 }
            if !switchDoor && won { stayWins += 1 }
        }
        
        // Reveal all
        phase = .result
        for index in doors.indices {
            doors[index].state = .open
        }
    }
    
    // Stats Helpers
    var stayWinRate: Double {
        stayTrials == 0 ? 0 : Double(stayWins) / Double(stayTrials)
    }
    
    var switchWinRate: Double {
        switchTrials == 0 ? 0 : Double(switchWins) / Double(switchTrials)
    }
    
    func resetStats() {
        stayWins = 0
        stayTrials = 0
        switchWins = 0
        switchTrials = 0
    }
}
