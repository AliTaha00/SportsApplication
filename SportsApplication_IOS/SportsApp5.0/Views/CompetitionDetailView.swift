import SwiftUI

struct CompetitionDetailView: View {
    let competition: Competition
    @StateObject private var standingsViewModel = StandingsViewModel()
    
    var body: some View {
        TabView {
            List {
                Section("Competition Info") {
                    HStack {
                        AsyncImage(url: URL(string: competition.emblem ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 100, height: 100)
                        
                        VStack(alignment: .leading) {
                            Text(competition.name)
                                .font(.headline)
                            if let area = competition.area {
                                Text(area.name)
                                    .font(.subheadline)
                            }
                            Text(competition.type)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Competition Details") {
                    NavigationLink(destination: StandingsView(standings: standingsViewModel.standings, competitionCode: competition.code ?? "")) {
                        Label("Standings", systemImage: "list.number")
                    }
                    
                    NavigationLink(destination: MatchesView(competitionCode: competition.code ?? "")) {
                        Label("Matches", systemImage: "sportscourt")
                    }
                    
                    NavigationLink(destination: TeamsView(competitionCode: competition.code ?? "")) {
                        Label("Teams", systemImage: "person.3")
                    }
                }
            }
            .navigationTitle(competition.name)
            .onAppear {
                standingsViewModel.fetchStandings(for: competition.code ?? "")
            }
            .tabItem {
                Label("Info", systemImage: "info.circle")
            }
            
            TopScorersView(competitionCode: competition.code ?? "")
                .tabItem {
                    Label("Top Scorers", systemImage: "soccerball")
                }
        }
    }
}

struct CompetitionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CompetitionDetailView(competition: Competition(
                id: 1,
                area: CompetitionArea(id: 2072, name: "England", code: "ENG", flag: nil),
                name: "Premier League",
                code: "PL",
                type: "LEAGUE",
                emblem: "https://crests.football-data.org/PL.png",
                plan: "TIER_ONE",
                currentSeason: nil,
                numberOfAvailableSeasons: 0,
                lastUpdated: ""
            ))
        }
    }
} 
