import Foundation

class TeamViewModel: ObservableObject {
    @Published var team: Team?
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchTeam(id: Int) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://api.football-data.org/v4/teams/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Api_Key", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let team = try JSONDecoder().decode(Team.self, from: data)
                    self?.team = team
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }
} 
