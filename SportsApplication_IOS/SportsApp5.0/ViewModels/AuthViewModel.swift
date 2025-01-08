import Foundation
import ParseSwift

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var error: String?
    @Published var isLoading = false
    
    init() {
        // Check if user is already logged in
        currentUser = User.current
        isAuthenticated = currentUser != nil
    }
    
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        error = nil
        
        var user = User()
        user.username = username
        user.email = email
        user.password = password
        
        user.signup { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
    
    func login(username: String, password: String) {
        isLoading = true
        error = nil
        
        User.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        User.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
    
    func updateFavoriteTeam(teamId: Int) {
        isLoading = true
        error = nil
        
        // Get current user
        guard var currentUser = User.current else {
            error = "No user logged in"
            isLoading = false
            return
        }
        
        // Update the favoriteTeamId
        currentUser.favoriteTeamId = teamId
        
        // Save to Parse
        currentUser.save { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let updatedUser):
                    self?.currentUser = updatedUser
                    print("✅ Successfully updated favorite team")
                case .failure(let error):
                    self?.error = error.localizedDescription
                    print("❌ Error updating favorite team: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeFavoriteTeam() {
        updateFavoriteTeam(teamId: -1) // Use -1 or another invalid ID to indicate no favorite team
    }
} 