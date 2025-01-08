import Foundation

// Base models used across multiple features
struct Season: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let currentMatchday: Int?
    let winner: Winner?
}

struct Winner: Codable {
    let id: Int
    let name: String
    let shortName: String
    let tla: String
    let crest: String?
}

struct CompetitionArea: Codable, Identifiable {
    let id: Int
    let name: String
    let code: String
    let flag: String?
}

struct Competition: Codable, Identifiable {
    let id: Int
    let area: CompetitionArea?
    let name: String
    let code: String?
    let type: String
    let emblem: String?
    let plan: String?
    let currentSeason: Season?
    let numberOfAvailableSeasons: Int?
    let lastUpdated: String?
} 