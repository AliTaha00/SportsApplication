import SwiftUI

struct TopScorersView: View {
    let competitionCode: String
    @StateObject private var viewModel = TopScorersViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Top Scorers")
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
                    ForEach(Array(viewModel.scorers.enumerated()), id: \.element.id) { index, scorer in
                        ScorerRow(scorer: scorer, rank: index + 1)
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
