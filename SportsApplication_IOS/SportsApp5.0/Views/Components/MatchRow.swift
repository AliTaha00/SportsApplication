import SwiftUI

struct MatchRow: View {
    let match: Match
    let teamId: Int
    
    private func formatTime(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        }
        return ""
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Time on the left
            Text(formatTime(match.utcDate))
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .frame(width: 50, alignment: .leading)
            
            // Teams and scores in one row each
            VStack(alignment: .leading, spacing: 12) {
                // Home team row
                HStack {
                    if let crestUrl = match.homeTeam.crest {
                        AsyncImage(url: URL(string: crestUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 24, height: 24)
                    }
                    
                    Text(match.homeTeam.shortName ?? match.homeTeam.name)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Text("\(match.score.fullTime?.home ?? 0)")
                        .font(.system(size: 16))
                }
                
                // Away team row
                HStack {
                    if let crestUrl = match.awayTeam.crest {
                        AsyncImage(url: URL(string: crestUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 24, height: 24)
                    }
                    
                    Text(match.awayTeam.shortName ?? match.awayTeam.name)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Text("\(match.score.fullTime?.away ?? 0)")
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
} 