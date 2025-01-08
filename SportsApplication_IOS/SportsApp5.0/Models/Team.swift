import Foundation

struct TeamsResponse: Codable {
    let count: Int
    let filters: Filters
    let competition: Competition
    let season: Season
    let teams: [Team]
}

struct Filters: Codable {
    let season: Int
}

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let shortName: String?
    let tla: String?
    let crest: String
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors: String?
    let venue: String?
    let coach: Coach?
    let squad: [Player]?
}

struct Coach: Codable {
    let id: Int
    let name: String
    let nationality: String?
    let dateOfBirth: String?
}

struct Contract: Codable {
    let start: String?
    let until: String?
}

struct Player: Codable, Identifiable {
    let id: Int
    let name: String
    let position: String?
    let dateOfBirth: String?
    let nationality: String?
    let shirtNumber: Int?
}

