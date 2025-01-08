import Foundation

class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchMatches(for competitionCode: String) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/competitions/\(competitionCode)/matches") else {
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
                    let response = try JSONDecoder().decode(MatchesResponse.self, from: data)
                    self?.matches = response.matches
                } catch {
                    print("Decoding Error: \(error)")
                    self?.error = error
                }
            }
        }.resume()
    }
} 