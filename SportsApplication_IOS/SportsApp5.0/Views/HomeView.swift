import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Matches")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 4)
            
            DateSelectorView(
                selectedDayOffset: viewModel.selectedDayOffset,
                namespace: namespace
            ) { offset in
                viewModel.selectDay(offset: offset)
            }
            
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack(spacing: 20) {
                        // Favorite Team Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Team's Match")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            if let favoriteMatch = viewModel.favoriteTeamMatch {
                                VStack(spacing: 1) {
                                    MatchRow(match: favoriteMatch, teamId: User.current?.favoriteTeamId ?? 0)
                                        .background(Color(.systemBackground))
                                }
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            } else {
                                VStack {
                                    Text("No matches scheduled for your team today")
                                        .foregroundColor(.secondary)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Other Matches
                        ForEach(viewModel.todaysMatches, id: \.0) { competition, matches in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(competition)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 1) {
                                    ForEach(matches) { match in
                                        MatchRow(match: match, teamId: 0)
                                            .background(Color(.systemBackground))
                                    }
                                }
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .refreshable {
                await viewModel.fetchMatches()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Date selector component
struct DateSelectorView: View {
    let selectedDayOffset: Int
    let namespace: Namespace.ID
    let onDateSelected: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(daysInWeek(), id: \.self) { date in
                    let calendar = Calendar.current
                    let startOfToday = calendar.startOfDay(for: Date())
                    let startOfDate = calendar.startOfDay(for: date)
                    let dayOffset = calendar.dateComponents([.day], from: startOfToday, to: startOfDate).day ?? 0
                    
                    DayButton(
                        date: date,
                        isSelected: dayOffset == selectedDayOffset,
                        namespace: namespace
                    ) {
                        onDateSelected(dayOffset)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private func daysInWeek() -> [Date] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        return (0...6).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfToday)
        }
    }
}

// Matches content component
struct MatchesContentView: View {
    let viewModel: HomeViewModel
    let isLoading: Bool
    let matches: [String: [Match]]
    
    private let topLeagues = [
        "Premier League",
        "LaLiga",
        "Bundesliga",
        "Serie A",
        "Ligue 1"
    ]
    
    private func getLeaguePriority(_ competition: String) -> Int {
        topLeagues.firstIndex(of: competition) ?? Int.max
    }
    
    private var sortedCompetitions: [String] {
        matches.keys.sorted { first, second in
            let firstPriority = getLeaguePriority(first)
            let secondPriority = getLeaguePriority(second)
            
            if firstPriority == secondPriority {
                return first < second
            }
            return firstPriority < secondPriority
        }
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .transition(.opacity)
            } else if matches.isEmpty {
                Text("No matches on this day")
                    .foregroundColor(.secondary)
                    .transition(.scale.combined(with: .opacity))
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.todaysMatches, id: \.0) { competition, matches in
                        Section(header: Text(competition)) {
                            ForEach(matches) { match in
                                MatchRow(match: match, teamId: 0)
                            }
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: matches.isEmpty)
    }
}

struct MatchListItem: View {
    let match: Match
    
    var body: some View {
        HStack(spacing: 20) {
            // Time
            Text(formatMatchTime(match.utcDate))
                .font(.title3)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            // Teams and scores in vertical layout
            VStack(alignment: .leading, spacing: 9) {
                // Home team
                HStack(spacing: 12) {
                    if let crest = match.homeTeam.crest {
                        AsyncImage(url: URL(string: crest)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 25, height: 25)
                    }
                    Text(getShortTeamName(match.homeTeam))
                        .font(.title3)
                    
                    Spacer()
                    
                    Text("\(match.score.fullTime?.home ?? 0)")
                        .font(.title3.bold())
                }
                
                // Away team
                HStack(spacing: 12) {
                    if let crest = match.awayTeam.crest {
                        AsyncImage(url: URL(string: crest)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 25, height: 25)
                    }
                    Text(getShortTeamName(match.awayTeam))
                        .font(.title3)
                    
                    Spacer()
                    
                    Text("\(match.score.fullTime?.away ?? 0)")
                        .font(.title3.bold())
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
    }
    
    private func formatMatchTime(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "HH:mm"
        return displayFormatter.string(from: date)
    }
    
    private func getShortTeamName(_ team: MatchTeam) -> String {
        if let shortName = team.shortName {
            return shortName
        }
        let name = team.name
        return name.count > 3 ? String(name.prefix(3)) : name
    }
}

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayOfWeek)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(dayNumber)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(monthName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 50, height: 70)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .matchedGeometryEffect(id: "selectedDay", in: namespace)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    }
                }
            )
        }
    }
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
}
