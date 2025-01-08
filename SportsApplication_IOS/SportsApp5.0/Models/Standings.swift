import Foundation

struct StandingsResponse: Codable {
    let filters: StandingsFilters?
    let area: CompetitionArea?
    let competition: Competition
    let season: Season?
    let standings: [Standing]
}

struct StandingsFilters: Codable {
    let season: String?
}

struct Standing: Codable {
    let stage: String
    let type: String
    let group: String?
    let table: [TableEntry]
}

struct TableEntry: Codable, Identifiable, Hashable {
    let position: Int
    let team: TeamStanding
    let playedGames: Int
    let form: String?
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    
    var id: Int { position }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(team.id)
        hasher.combine(position)
    }
    
    static func == (lhs: TableEntry, rhs: TableEntry) -> Bool {
        return lhs.team.id == rhs.team.id && lhs.position == rhs.position
    }
}

struct TeamStanding: Codable {
    let id: Int
    let name: String
    let shortName: String
    let tla: String
    let crest: String
} 