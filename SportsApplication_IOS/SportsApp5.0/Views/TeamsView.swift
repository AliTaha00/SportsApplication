import SwiftUI

struct TeamsView: View {
    @StateObject private var viewModel = TeamsViewModel()
    let competitionCode: String
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ForEach(viewModel.teams) { team in
                    NavigationLink(destination: TeamDetailView(teamId: team.id, competitionCode: competitionCode)) {
                        HStack {
                            AsyncImage(url: URL(string: team.crest)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text(team.name)
                                    .font(.headline)
                                if let founded = team.founded {
                                    Text("Founded: \(founded)")
                                        .font(.subheadline)
                                }
                                if let colors = team.clubColors {
                                    Text(colors)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Teams")
        .onAppear {
            viewModel.fetchTeams(for: competitionCode)
        }
    }
} 