import Foundation

struct TeamMatchesResponse: Codable {
    let matches: [Match]
}

struct MatchesResponse: Codable {
    let filters: MatchFilters?
    let resultSet: ResultSet?
    let matches: [Match]
}

struct ResultSet: Codable {
    let count: Int
    let competitions: String?
    let first: String?
    let last: String?
    let played: Int?
}

struct MatchFilters: Codable {
    let dateFrom: String?
    let dateTo: String?
    let permission: String?
    let season: String?
    let status: [String]?
    let stage: String?
    let limit: Int?
    let competitions: String?
    let areas: [String]?
}

struct Match: Identifiable, Codable {
    let id: Int?
    let utcDate: String
    let status: String
    let homeTeam: MatchTeam
    let awayTeam: MatchTeam
    let score: Score
    let competition: Competition?
    
    var identifier: Int {
        return id ?? UUID().hashValue
    }
    
    struct Score: Codable {
        let winner: String?
        let duration: String?
        let fullTime: FullTimeScore?
        let halfTime: FullTimeScore?
    }
    
    struct FullTimeScore: Codable {
        let home: Int?
        let away: Int?
    }
}

struct MatchTeam: Codable {
    let id: Int?
    let name: String
    let shortName: String?
    let tla: String?
    let crest: String?
} 