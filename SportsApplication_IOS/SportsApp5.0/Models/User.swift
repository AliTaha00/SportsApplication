import Foundation
import ParseSwift

struct User: ParseUser {
    // Required by ParseUser
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    // Custom properties
    var favoriteTeam: Team?
    var favoriteTeamId: Int?
    
    // Required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Make User conform to Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.objectId == rhs.objectId
    }
} 