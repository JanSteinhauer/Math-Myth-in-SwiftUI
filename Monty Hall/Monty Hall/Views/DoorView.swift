import SwiftUI

struct DoorView: View {
    let door: Door
    let action: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 1. Content Layer (Always flat, sits behind)
                if door.state == .revealed || door.state == .open {
                    Text(door.content == .car ? "🚗" : "🐐")
                        .font(.system(size: 50))
                }
                
                // 2. Door Cover Layer (Rotates open)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(doorColor)
                        .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(borderColor, lineWidth: 3)
                        )
                    
                    VStack {
                        Text("Door")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(door.id + 1)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Knob
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 8, height: 8)
                        .offset(x: 30, y: 0)
                }
                .opacity((door.state == .revealed || door.state == .open) ? 0 : 1) // Fade out slightly if needed or just rotate
                // Actually, for a pure 3D open effect, we want the door to rotate 
                // and the content to be behind it. 
                // But since we are looking top-down or 2D, a simple rotation might not look like "opening a door" 
                // if we don't have a backside.
                // Let's try the "Swing Open" effect where the door rotates and fades or moves aside.
                // The user asked for "spring back", suggesting they liked the rotation but not that the content rotated.
                
                // REVISED APPROACH based on User Request:
                // Keep the Door Cover opaque, and rotate it open to reveal the content behind.
                
                .rotation3DEffect(
                    .degrees((door.state == .revealed || door.state == .open) ? -85 : 0), // Rotate "open"
                    axis: (x: 0, y: 1, z: 0),
                    anchor: .leading,
                    perspective: 0.5
                )
            }
        }
        .frame(height: 140)
        .disabled(door.state == .revealed || door.state == .open)
        .scaleEffect(isAnimating ? 0.95 : 1.0)
    }
    
    private var doorColor: Color {
        switch door.state {
        case .closed: return Color.blue
        case .selected: return Color.orange
        case .revealed: return Color.gray.opacity(0.5) // Open door visually fades or is just the "back of the door"
        case .open: return Color.green.opacity(0.5) // Final reveal
        }
    }
    
    private var borderColor: Color {
        switch door.state {
        case .selected: return Color.yellow
        default: return Color.clear
        }
    }
    
    private var shadowColor: Color {
        return door.state == .selected ? Color.orange.opacity(0.5) : Color.black.opacity(0.2)
    }
}

#Preview {
    HStack {
        DoorView(door: Door(id: 0, content: .goat, state: .closed), action: {})
        DoorView(door: Door(id: 1, content: .car, state: .selected), action: {})
        DoorView(door: Door(id: 2, content: .goat, state: .revealed), action: {})
    }
    .padding()
}
