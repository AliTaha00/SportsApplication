import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var teamViewModel = TeamViewModel()
    @State private var showLeagueSelection = false
    
    var body: some View {
        List {
            if let user = authViewModel.currentUser {
                Section("Account") {
                    Text("Username: \(user.username ?? "")")
                    Text("Email: \(user.email ?? "")")
                }
                
                Section("Favorite Team") {
                    if let favoriteTeamId = user.favoriteTeamId {
                        if teamViewModel.isLoading {
                            ProgressView()
                        } else if let team = teamViewModel.team {
                            HStack {
                                AsyncImage(url: URL(string: team.crest)) { image in
                                    image.resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading) {
                                    Text(team.name)
                                        .font(.headline)
                                    if let founded = team.founded {
                                        Text("Founded: \(founded)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                            
                            Button(action: {
                                showLeagueSelection = true
                            }) {
                                Text("Change Favorite Team")
                            }
                            
                            Button(role: .destructive, action: {
                                authViewModel.removeFavoriteTeam()
                            }) {
                                Text("Remove Favorite Team")
                            }
                        }
                    } else {
                        Button(action: {
                            showLeagueSelection = true
                        }) {
                            Text("Select Favorite Team")
                        }
                    }
                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    authViewModel.logout()
                }) {
                    Text("Logout")
                }
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showLeagueSelection) {
            FavoriteTeamSelectionView(authViewModel: authViewModel)
        }
        .onChange(of: authViewModel.currentUser?.favoriteTeamId) { newTeamId in
            if let teamId = newTeamId {
                teamViewModel.fetchTeam(id: teamId)
            }
        }
        .onAppear {
            if let teamId = authViewModel.currentUser?.favoriteTeamId {
                teamViewModel.fetchTeam(id: teamId)
            }
        }
    }
} 