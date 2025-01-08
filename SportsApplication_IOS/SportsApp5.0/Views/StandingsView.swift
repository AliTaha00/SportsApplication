import SwiftUI

struct StandingsView: View {
    let standings: [TableEntry]
    let competitionCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Standings")
                .font(.system(size: 34, weight: .bold))
                .padding(.horizontal)
                .padding(.bottom, 16)
                .background(Color(.systemBackground))
            
            List {
                StandingsHeaderRow()
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                ForEach(standings) { entry in
                    VStack(spacing: 0) {
                        StandingsRow(entry: entry, competitionCode: competitionCode)
                        Divider()
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Header Row Component
struct StandingsHeaderRow: View {
    var body: some View {
        HStack {
            Text("#")
                .frame(width: 22)
            Text("Team")
                .frame(width: 130, alignment: .leading)
            
            HStack(spacing: 8) {
                Text("GP")
                    .frame(width: 22)
                Text("W")
                    .frame(width: 22)
                Text("D")
                    .frame(width: 22)
                Text("L")
                    .frame(width: 22)
                Text("GD")
                    .frame(width: 28)
                Text("Pts")
                    .frame(width: 28)
            }
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

// Content Rows Component
struct StandingsContentRows: View {
    let standings: [TableEntry]
    let competitionCode: String
    
    var body: some View {
        ForEach(standings) { entry in
            StandingsRow(entry: entry, competitionCode: competitionCode)
        }
    }
}

// Individual Row Component
struct StandingsRow: View {
    let entry: TableEntry
    let competitionCode: String
    
    var body: some View {
        NavigationLink(destination: TeamDetailView(teamId: entry.team.id, competitionCode: competitionCode)) {
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 4)
                    .foregroundColor(qualificationZoneColor)
                
                HStack {
                    Text("\(entry.position)")
                        .frame(width: 22)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        AsyncImage(url: URL(string: entry.team.crest)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 22, height: 22)
                        
                        VStack(alignment: .leading) {
                            Text(entry.team.shortName)
                                .lineLimit(1)
                            HStack(spacing: 2) {
                                ForEach(Array(formArray.enumerated()), id: \.offset) { _, result in
                                    Circle()
                                        .fill(formColor(result))
                                        .frame(width: 5, height: 5)
                                }
                            }
                        }
                    }
                    .frame(width: 130, alignment: .leading)
                    
                    HStack(spacing: 8) {
                        Text("\(entry.playedGames)")
                            .frame(width: 22)
                        Text("\(entry.won)")
                            .frame(width: 22)
                        Text("\(entry.draw)")
                            .frame(width: 22)
                        Text("\(entry.lost)")
                            .frame(width: 22)
                        Text("\(entry.goalDifference)")
                            .frame(width: 28)
                        Text("\(entry.points)")
                            .frame(width: 28)
                            .bold()
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .font(.system(size: 14))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formArray: [String] {
        guard let form = entry.form else { return [] }
        return form.split(separator: ",")
            .prefix(5)
            .map(String.init)
    }
    
    private func formColor(_ form: String) -> Color {
        switch form {
        case "W": return .green
        case "D": return .gray
        case "L": return .red
        default: return .secondary
        }
    }
    
    private var qualificationZoneColor: Color {
        switch entry.position {
        case 1...4: return .blue       // Champions League
        case 5: return .orange         // Europa League
        case 6: return .green          // Conference League
        case 18...20: return .red      // Relegation
        default: return .clear
        }
    }
}

// Position Indicator Component with relegation spots
struct PositionIndicator: View {
    let position: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(getPositionColor())
                .frame(width: 4)
                .frame(height: 20)
                .opacity(shouldShowIndicator() ? 1 : 0)
            
            Text("\(position)")
                .frame(width: 24)
                .font(.system(size: 14))
                .foregroundColor(position >= 18 ? .red : .primary)
        }
        .frame(width: 28)
    }
    
    private func getPositionColor() -> Color {
        switch position {
        case 1...4: return .blue       // Champions League
        case 5...7: return .orange     // Europa League
        case 18...20: return .red      // Relegation
        default: return .clear
        }
    }
    
    private func shouldShowIndicator() -> Bool {
        position <= 7 || position >= 18
    }
}

// Form Indicator Component
struct FormIndicator: View {
    let form: String?
    
    var body: some View {
        if let form = form {
            HStack(spacing: 2) {
                ForEach(form.components(separatedBy: ","), id: \.self) { result in
                    Circle()
                        .fill(getFormColor(result: result))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
    
    private func getFormColor(result: String) -> Color {
        switch result.trimmingCharacters(in: .whitespaces) {
        case "W": return .green
        case "D": return .gray
        case "L": return .red
        default: return .clear
        }
    }
}

// Updated Team Info Component with Form
struct TeamInfo: View {
    let team: TeamStanding
    let form: String?
    
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: team.crest)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(team.shortName)
                    .lineLimit(1)
                    .font(.system(size: 14))
                FormIndicator(form: form)
            }
        }
        .frame(width: 135, alignment: .leading)
    }
}

// Stats Info Component
struct StatsInfo: View {
    let entry: TableEntry
    
    var body: some View {
        HStack(spacing: 14) {
            Text("\(entry.playedGames)")
                .frame(width: 28)
            Text("\(entry.won)")
                .frame(width: 28)
            Text("\(entry.draw)")
                .frame(width: 28)
            Text("\(entry.lost)")
                .frame(width: 28)
            Text("\(entry.goalDifference)")
                .frame(width: 32)
            Text("\(entry.points)")
                .frame(width: 32)
                .bold()
        }
        .font(.system(size: 14))
    }
}