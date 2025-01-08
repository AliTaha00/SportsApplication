import SwiftUI

struct ScorerRow: View {
    let scorer: Scorer
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 30)
            
            AsyncImage(url: URL(string: scorer.team.crest)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scorer.player.name)
                    .font(.headline)
                Text(scorer.team.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "soccerball")
                    .foregroundColor(.green)
                Text("\(scorer.goals)")
                    .font(.headline)
                
                if let penalties = scorer.penalties, penalties > 0 {
                    Text("(\(penalties)p)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
} 