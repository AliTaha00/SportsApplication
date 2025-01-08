import SwiftUI

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    let competitionCode: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(viewModel.matches) { match in
                        CompetitionMatchRow(match: match)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Matches")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.fetchMatches(for: competitionCode)
        }
    }
} 