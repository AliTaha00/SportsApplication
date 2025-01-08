import Foundation

class StandingsViewModel: ObservableObject {
    @Published var standings: [TableEntry] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchStandings(for competitionCode: String) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/competitions/\(competitionCode)/standings") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("552ae297c3394824a50683ddf0f63221", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let response = try JSONDecoder().decode(StandingsResponse.self, from: data)
                    if let tableEntries = response.standings.first?.table {
                        self?.standings = tableEntries
                    }
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }
    
    func fetchStandingsAsync(for competitionCode: String) async {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/competitions/\(competitionCode)/standings") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("552ae297c3394824a50683ddf0f63221", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(StandingsResponse.self, from: data)
            DispatchQueue.main.async {
                self.standings = response.standings.first?.table ?? []
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
                self.isLoading = false
            }
        }
    }
} 