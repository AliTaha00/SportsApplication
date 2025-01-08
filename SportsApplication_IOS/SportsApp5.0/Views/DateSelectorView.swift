import SwiftUI

struct DateSelectorView: View {
    let selectedDayOffset: Int
    let namespace: Namespace.ID
    let onDateSelected: (Int) -> Void
    @State private var currentWeekOffset = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(daysInCurrentWeek(), id: \.self) { date in
                    let dayOffset = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: date)).day ?? 0
                    
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
    
    private func daysInCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        // Find the start of the current week (Monday)
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        components.weekOfYear = (components.weekOfYear ?? 0) + currentWeekOffset
        components.weekday = 2 // Monday
        
        guard let startOfWeek = calendar.date(from: components) else { return [] }
        
        // Create array of dates for the week
        return (0...6).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
}

struct DayButton: View {
    let date: Date
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(dayOfWeek)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(dayNumber)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 60, height: 70)
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
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}