import SwiftUI

struct TopAssistsView: View {
    let competitionCode: String
    @StateObject private var viewModel = TopScorersViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Top Assists")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 4)
                Text("Season 2024/25")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .background(Color(.systemBackground))
            
            List {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    let sortedByAssists = viewModel.scorers
                        .sorted { ($0.assists ?? 0) > ($1.assists ?? 0) }
                        .prefix(10)
                    
                    ForEach(Array(sortedByAssists.enumerated()), id: \.element.id) { index, scorer in
                        AssistRow(scorer: scorer, rank: index + 1)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            viewModel.fetchScorers(for: competitionCode)
        }
    }
}

struct AssistRow: View {
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
                Image(systemName: "figure.soccer")
                    .foregroundColor(.blue)
                Text("\(scorer.assists ?? 0)")
                    .font(.headline)
            }
        }
        .padding(.vertical, 8)
    }
} 