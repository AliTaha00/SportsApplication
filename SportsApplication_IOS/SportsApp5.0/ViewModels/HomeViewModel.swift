import Foundation

class HomeViewModel: ObservableObject {
    @Published var todaysMatches: [(String, [Match])] = []
    @Published var favoriteTeamMatch: Match?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedDayOffset = 0
    
    private let apiKey = "Api_Key"
    private var currentTask: Task<Void, Never>?
    
    private let leaguePriorities: [String: Int] = [
        "UEFA Champions League": 1,
        "Premier League": 2,
        "Primera Division": 3,
        "Bundesliga": 4,
        "Serie A": 5,
        "Ligue 1": 6
    ]
    
    init() {
        fetchMatchesForToday()
    }
    
    func selectDay(offset: Int) {
        selectedDayOffset = offset
        fetchMatchesForToday()
    }
    
    func fetchMatchesForToday() {
        currentTask?.cancel()
        currentTask = Task {
            await fetchMatches()
        }
    }
    
    @MainActor
    func fetchMatches() async {
        isLoading = true
        error = nil
        
        // Calculate the selected date based on the offset
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        
        guard let selectedDate = calendar.date(byAdding: .day, value: selectedDayOffset, to: now) else {
            return
        }
        
        // Create date formatter for API request
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        
        // Get the date string for the API
        let dateString = dateFormatter.string(from: selectedDate)
        
        print("Selected date in local time: \(selectedDate)")
        print("API date string: \(dateString)")
        
        guard let url = URL(string: "https://api.football-data.org/v4/matches?date=\(dateString)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            let matchesResponse = try JSONDecoder().decode(MatchesResponse.self, from: data)
            
            // Debug print each match date
            for match in matchesResponse.matches {
                print("Match date from API: \(match.utcDate)")
            }
            
            // Group matches by competition
            let grouped = Dictionary(grouping: matchesResponse.matches) { match in
                match.competition?.name ?? "Other Competitions"
            }
            
            // Sort the competitions
            let sortedMatches = grouped.sorted { (first, second) in
                let firstPriority = leaguePriorities[first.key] ?? 999
                let secondPriority = leaguePriorities[second.key] ?? 999
                return firstPriority < secondPriority
            }
            
            // Store as array of tuples instead of dictionary to maintain order
            todaysMatches = sortedMatches
            
            if let favoriteTeamId = User.current?.favoriteTeamId {
                favoriteTeamMatch = matchesResponse.matches.first { match in
                    match.homeTeam.id == favoriteTeamId || match.awayTeam.id == favoriteTeamId
                }
            } else {
                favoriteTeamMatch = nil
            }
            
            isLoading = false
            
        } catch {
            self.error = error
            isLoading = false
            print("Error fetching matches: \(error)")
        }
    }
    
    func fetchMatches(for dayOffset: Int) {
        isLoading = true
        error = nil
        
        // Calculate the target date in user's local timezone
        let calendar = Calendar.current
        guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: Date())) else {
            return
        }
        
        // Create date interval for the entire target day in user's timezone
        guard let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: targetDate),
              let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: targetDate) else {
            return
        }
        
        // Convert to UTC for API request
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: targetDate)
        
        // Create URL with date parameter
        guard let url = URL(string: "https://api.football-data.org/v4/matches?date=\(dateString)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("552ae297c3394824a50683ddf0f63221", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.error = error
                    self?.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                return
            }
            
            do {
                let matchesResponse = try JSONDecoder().decode(MatchesResponse.self, from: data)
                
                // Group matches by competition
                let grouped = Dictionary(grouping: matchesResponse.matches) { match in
                    match.competition?.name ?? "Other Competitions"
                }
                
                // Sort the competitions
                let sortedMatches = grouped.sorted { (first, second) in
                    let firstPriority = self?.leaguePriorities[first.key] ?? 999
                    let secondPriority = self?.leaguePriorities[second.key] ?? 999
                    return firstPriority < secondPriority
                }
                
                DispatchQueue.main.async {
                    self?.todaysMatches = sortedMatches
                    
                    if let favoriteTeamId = User.current?.favoriteTeamId {
                        self?.favoriteTeamMatch = matchesResponse.matches.first { match in
                            match.homeTeam.id == favoriteTeamId || match.awayTeam.id == favoriteTeamId
                        }
                    } else {
                        self?.favoriteTeamMatch = nil
                    }
                    
                    self?.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self?.error = error
                    self?.isLoading = false
                }
            }
        }.resume()
    }
    
    // Helper function to convert UTC date string to local time
    private func convertUTCToLocal(_ utcDateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        guard let utcDate = formatter.date(from: utcDateString) else {
            return nil
        }
        return utcDate
    }
}
