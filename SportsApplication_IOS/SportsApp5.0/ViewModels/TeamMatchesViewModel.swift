import Foundation

class TeamMatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var stats = TeamStats()
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiKey = "552ae297c3394824a50683ddf0f63221"
    
    var lastFiveMatches: [Match] {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        let today = Date()
        
        // Filter for FINISHED matches that happened before today
        let finishedMatches = matches.filter { match in
            guard let matchDate = dateFormatter.date(from: match.utcDate) else {
                return false
            }
            return match.status == "FINISHED" && matchDate < today
        }
        
        // Sort by date (most recent first)
        let sortedMatches = finishedMatches.sorted { match1, match2 in
            guard let date1 = dateFormatter.date(from: match1.utcDate),
                  let date2 = dateFormatter.date(from: match2.utcDate) else {
                return false
            }
            return date1 > date2
        }
        
        // Take only the last 5 matches
        return Array(sortedMatches.prefix(5))
    }
    
    func fetchMatches(for teamId: Int, competition: String) {
        isLoading = true
        
        // Get dates for the last 6 months
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: today) ?? today
        
        let dateFromString = dateFormatter.string(from: sixMonthsAgo)
        let dateToString = dateFormatter.string(from: today)
        
        guard let url = URL(string: "https://api.football-data.org/v4/teams/\(teamId)/matches?competitions=\(competition)&dateFrom=\(dateFromString)&dateTo=\(dateToString)") else {
            return
        }
        
        print("Fetching URL: \(url)")
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching matches: \(error)")
                    self?.error = error
                    self?.isLoading = false
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    self?.isLoading = false
                    return
                }
                
                // Print raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response:")
                    print(jsonString)
                }
                
                do {
                    let response = try JSONDecoder().decode(TeamMatchesResponse.self, from: data)
                    print("Received \(response.matches.count) matches")
                    self?.matches = response.matches
                    self?.calculateStats(matches: response.matches, teamId: teamId)
                    self?.isLoading = false
                } catch {
                    print("Decoding error: \(error)")
                    self?.error = error
                    self?.isLoading = false
                }
            }
        }.resume()
    }
    
    private func calculateStats(matches: [Match], teamId: Int) {
        print("Starting stats calculation for team \(teamId)")
        var stats = TeamStats()
        
        // Filter for only finished matches
        let finishedMatches = matches.filter { $0.status == "FINISHED" }
        print("Found \(finishedMatches.count) finished matches")
        
        for match in finishedMatches {
            guard let homeScore = match.score.fullTime?.home,
                  let awayScore = match.score.fullTime?.away else {
                print("Skipping match - no scores available")
                continue
            }
            
            print("Processing match: \(match.homeTeam.name) \(homeScore) - \(awayScore) \(match.awayTeam.name)")
            stats.played += 1
            
            if match.homeTeam.id == teamId {
                print("Team played at home")
                if homeScore > awayScore {
                    stats.wins += 1
                    print("Win")
                } else if homeScore < awayScore {
                    stats.losses += 1
                    print("Loss")
                } else {
                    stats.draws += 1
                    print("Draw")
                }
            } else if match.awayTeam.id == teamId {
                print("Team played away")
                if awayScore > homeScore {
                    stats.wins += 1
                    print("Win")
                } else if awayScore < homeScore {
                    stats.losses += 1
                    print("Loss")
                } else {
                    stats.draws += 1
                    print("Draw")
                }
            }
        }
        
        print("Final stats - Played: \(stats.played), Wins: \(stats.wins), Draws: \(stats.draws), Losses: \(stats.losses)")
        
        DispatchQueue.main.async {
            self.stats = stats
        }
    }
}

struct TeamStats {
    var played: Int = 0
    var wins: Int = 0
    var draws: Int = 0
    var losses: Int = 0
}