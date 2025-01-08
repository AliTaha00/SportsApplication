import SwiftUI

struct FavoriteTeamView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var teamsViewModel = TeamsViewModel()
    @Environment(\.dismiss) private var dismiss
    let competitionCode: String
    
    var body: some View {
        List {
            if teamsViewModel.isLoading {
                ProgressView()
            } else {
                ForEach(teamsViewModel.teams) { team in
                    TeamRow(team: team, isSelected: authViewModel.currentUser?.favoriteTeamId == team.id)
                        .onTapGesture {
                            Task {
                                await authViewModel.updateFavoriteTeam(teamId: team.id)
                                // Dismiss all presentation modes
                                dismiss()
                                NotificationCenter.default.post(name: NSNotification.Name("DismissTeamSelection"), object: nil)
                            }
                        }
                }
            }
        }
        .navigationTitle("Select Team")
        .onAppear {
            teamsViewModel.fetchTeams(for: competitionCode)
        }
    }
}

struct TeamRow: View {
    let team: Team
    let isSelected: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: team.crest)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            
            Text(team.name)
                .font(.headline)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
    }
} 