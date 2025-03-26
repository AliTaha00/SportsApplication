import Foundation

class CompetitionsViewModel: ObservableObject {
    @Published var competitions: [Competition] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        fetchCompetitions()
    }
    
    func fetchCompetitions() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/competitions") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("API_key", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error
                    print("Network Error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(CompetitionsResponse.self, from: data)
                    self?.competitions = response.competitions
                    print("Fetched \(response.competitions.count) competitions")
                } catch {
                    print("Decoding Error: \(error)")
                    self?.error = error
                }
            }
        }.resume()
    }
} 
