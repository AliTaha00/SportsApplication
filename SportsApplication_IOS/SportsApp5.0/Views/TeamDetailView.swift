import Foundation
import SwiftUI

struct TeamDetailView: View {
    let teamId: Int
    let competitionCode: String
    @StateObject private var viewModel = TeamViewModel()
    @StateObject private var matchesViewModel = TeamMatchesViewModel()
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else if let team = viewModel.team {
                // Team Header Section
                Section {
                    VStack(alignment: .center, spacing: 16) {
                        AsyncImage(url: URL(string: team.crest)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(height: 120)
                        
                        VStack(spacing: 8) {
                            Text(team.name)
                                .font(.title2.bold())
                            if let shortName = team.shortName {
                                Text("(\(shortName))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            if let tla = team.tla {
                                Text(tla)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                
                // Club Information
                Section("Club Information") {
                    if let founded = team.founded {
                        InfoRow(label: "Founded", value: "\(founded)")
                    }
                    if let venue = team.venue {
                        InfoRow(label: "Stadium", value: venue)
                    }
                    if let colors = team.clubColors {
                        InfoRow(label: "Club Colors", value: colors)
                    }
                    if let address = team.address {
                        InfoRow(label: "Address", value: address)
                    }
                    if let website = team.website {
                        Link("Official Website", destination: URL(string: website)!)
                            .foregroundColor(.blue)
                    }
                }
                
                // Manager/Coach Section
                if let coach = team.coach {
                    Section("Manager") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(coach.name)
                                .font(.headline)
                            if let nationality = coach.nationality {
                                Text("Nationality: \(nationality)")
                                    .font(.subheadline)
                            }
                            if let dateOfBirth = coach.dateOfBirth {
                                Text("Born: \(formatDate(dateOfBirth))")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Team Statistics
                Section("Statistics") {
                    HStack(spacing: 8) {
                        StatBox(label: "Played", value: matchesViewModel.stats.played)
                        StatBox(label: "Wins", value: matchesViewModel.stats.wins)
                        StatBox(label: "Draws", value: matchesViewModel.stats.draws)
                        StatBox(label: "Losses", value: matchesViewModel.stats.losses)
                    }
                }
                
                // Squad Section with Position Grouping
                if let squad = team.squad {
                    Section("Squad") {
                        ForEach(squad, id: \.id) { player in
                            PlayerRow(player: player)
                        }
                    }
                }
                
                // Last 5 Matches
                Section("Recent Matches") {
                    ForEach(Array(matchesViewModel.matches
                        .sorted(by: { $0.utcDate > $1.utcDate })
                        .prefix(5))) { match in
                        MatchRow(match: match, teamId: teamId)
                    }
                }
            }
        }
        .navigationTitle(viewModel.team?.shortName ?? "Team Details")
        .onAppear {
            viewModel.fetchTeam(id: teamId)
            matchesViewModel.fetchMatches(for: teamId, competition: competitionCode)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
