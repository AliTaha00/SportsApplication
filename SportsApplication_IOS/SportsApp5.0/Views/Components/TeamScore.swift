import SwiftUI

struct TeamScore: View {
    let name: String
    let crest: String?
    let score: Int?
    let isHome: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            if !isHome {
                scoreView
                teamInfo
            } else {
                teamInfo
                scoreView
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var teamInfo: some View {
        HStack(spacing: 8) {
            if let crestURL = crest {
                AsyncImage(url: URL(string: crestURL)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 24, height: 24)
            }
            
            Text(name)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private var scoreView: some View {
        Text("\(score ?? 0)")
            .font(.headline)
            .foregroundColor(score == nil ? .secondary : .primary)
    }
} 