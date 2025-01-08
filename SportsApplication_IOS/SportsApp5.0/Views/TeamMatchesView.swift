import SwiftUI

struct TeamMatchesView: View {
    @StateObject private var viewModel = TeamMatchesViewModel()
    let team: Team
    let competitionCode: String
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Section("Statistics") {
                    HStack(spacing: 8) {
                        StatBox(label: "Played", value: viewModel.stats.played)
                        StatBox(label: "Wins", value: viewModel.stats.wins)
                        StatBox(label: "Draws", value: viewModel.stats.draws)
                        StatBox(label: "Losses", value: viewModel.stats.losses)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Last 5 Matches") {
                    ForEach(viewModel.lastFiveMatches) { match in
                        MatchRow(match: match, teamId: team.id)
                    }
                }
            }
        }
        .navigationTitle("Matches")
        .onAppear {
            viewModel.fetchMatches(for: team.id, competition: competitionCode)
        }
    }
}
