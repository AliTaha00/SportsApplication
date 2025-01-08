import SwiftUI

struct FavoriteTeamSelectionView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCompetition: Competition?
    
    // Top 5 leagues codes
    private let topLeagues = [
        Competition(
            id: 2021,
            area: CompetitionArea(id: 2072, name: "England", code: "ENG", flag: nil),
            name: "Premier League",
            code: "PL",
            type: "LEAGUE",
            emblem: "https://crests.football-data.org/PL.png",
            plan: nil,
            currentSeason: nil,
            numberOfAvailableSeasons: nil,
            lastUpdated: nil
        ),
        Competition(
            id: 2014,
            area: CompetitionArea(id: 2224, name: "Spain", code: "ESP", flag: nil),
            name: "La Liga",
            code: "PD",
            type: "LEAGUE",
            emblem: "https://crests.football-data.org/PD.png",
            plan: nil,
            currentSeason: nil,
            numberOfAvailableSeasons: nil,
            lastUpdated: nil
        ),
        Competition(
            id: 2002,
            area: CompetitionArea(id: 2088, name: "Germany", code: "DEU", flag: nil),
            name: "Bundesliga",
            code: "BL1",
            type: "LEAGUE",
            emblem: "https://crests.football-data.org/BL1.png",
            plan: nil,
            currentSeason: nil,
            numberOfAvailableSeasons: nil,
            lastUpdated: nil
        ),
        Competition(
            id: 2019,
            area: CompetitionArea(id: 2114, name: "Italy", code: "ITA", flag: nil),
            name: "Serie A",
            code: "SA",
            type: "LEAGUE",
            emblem: "https://crests.football-data.org/SA.png",
            plan: nil,
            currentSeason: nil,
            numberOfAvailableSeasons: nil,
            lastUpdated: nil
        ),
        Competition(
            id: 2015,
            area: CompetitionArea(id: 2081, name: "France", code: "FRA", flag: nil),
            name: "Ligue 1",
            code: "FL1",
            type: "LEAGUE",
            emblem: "https://crests.football-data.org/FL1.png",
            plan: nil,
            currentSeason: nil,
            numberOfAvailableSeasons: nil,
            lastUpdated: nil
        )
    ]
    
    var body: some View {
        NavigationView {
            List(topLeagues) { competition in
                NavigationLink {
                    FavoriteTeamView(
                        authViewModel: authViewModel,
                        competitionCode: competition.code ?? "PL"
                    )
                } label: {
                    CompetitionRow(competition: competition)
                }
            }
            .navigationTitle("Select League")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissTeamSelection"))) { _ in
                dismiss()
            }
        }
    }
} 