import Foundation

class TeamsViewModel: ObservableObject {
    private let baseURL = "https://api.football-data.org"
    private let apiKey = "API_Key"
    
    @Published var teams: [Team] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchTeams(for competitionCode: String) {
        isLoading = true
        print("🏆 Fetching teams for competition: \(competitionCode)")
        
        let urlString = "\(baseURL)/v4/competitions/\(competitionCode)/teams?season=2024"
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        print("📡 Sending request to: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    self?.error = error
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📊 HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("⚠️ Unexpected status code")
                    }
                }
                
                guard let data = data else {
                    print("❌ No data received")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📝 Raw JSON response: \(jsonString)")
                }
                
                do {
                    let response = try JSONDecoder().decode(TeamsResponse.self, from: data)
                    print("✅ Successfully decoded \(response.teams.count) teams")
                    self?.teams = response.teams
                } catch {
                    print("❌ Decoding error: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value of type '\(type)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    self?.error = error
                }
            }
        }.resume()
    }
} 
