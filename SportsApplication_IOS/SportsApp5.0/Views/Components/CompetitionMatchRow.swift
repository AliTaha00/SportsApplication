import SwiftUI

struct CompetitionMatchRow: View {
    let match: Match
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // Date
            Text(formatDate(match.utcDate))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Teams and Score
            HStack(spacing: 16) {
                // Home Team
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: match.homeTeam.crest ?? "")) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 30, height: 30)
                    
                    Text(match.homeTeam.shortName ?? match.homeTeam.name)
                        .font(.headline)
                }
                .frame(width: 120, alignment: .trailing)
                
                // Score
                HStack(spacing: 8) {
                    Text("\(match.score.fullTime?.home ?? 0)")
                        .font(.title3.bold())
                    Text("vs")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(match.score.fullTime?.away ?? 0)")
                        .font(.title3.bold())
                }
                .frame(width: 80)
                
                // Away Team
                HStack(spacing: 8) {
                    Text(match.awayTeam.shortName ?? match.awayTeam.name)
                        .font(.headline)
                    
                    AsyncImage(url: URL(string: match.awayTeam.crest ?? "")) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 30, height: 30)
                }
                .frame(width: 120, alignment: .leading)
            }
            
            // Status
            Text(match.status)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.vertical, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 