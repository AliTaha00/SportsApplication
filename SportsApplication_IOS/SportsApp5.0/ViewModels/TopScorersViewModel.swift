import Foundation

class TopScorersViewModel: ObservableObject {
    @Published var scorers: [Scorer] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiKey = "552ae297c3394824a50683ddf0f63221"
    
    func fetchScorers(for competitionCode: String) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/competitions/\(competitionCode)/scorers") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        print("Fetching scorers for competition: \(competitionCode)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error
                    print("Error fetching scorers: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ScorersResponse.self, from: data)
                    self?.scorers = response.scorers
                    print("Received \(response.scorers.count) scorers")
                } catch {
                    print("Decoding Error: \(error)")
                    self?.error = error
                }
            }
        }.resume()
    }
} 