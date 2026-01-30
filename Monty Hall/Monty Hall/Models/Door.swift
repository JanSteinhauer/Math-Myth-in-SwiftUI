import Foundation
import SwiftUI

struct Door: Identifiable, Equatable {
    let id: Int
    var content: DoorContent
    var state: DoorState = .closed
    
    enum DoorContent: Equatable {
        case goat
        case car
    }
    
    enum DoorState: Equatable {
        case closed
        case selected       // Player tapped this door (still closed)
        case revealed       // Host opened this door (shows content)
        case open           // Final result (shows content)
    }
}
