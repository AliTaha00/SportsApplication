import SwiftUI

struct PlayerRow: View {
    let player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.system(size: 14))
                if let position = player.position {
                    Text(position)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let number = player.shirtNumber {
                Text("#\(number)")
                    .font(.system(size: 14, weight: .bold))
            }
        }
    }
} 
