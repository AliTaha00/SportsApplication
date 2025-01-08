import SwiftUI

struct CompetitionsView: View {
    @StateObject private var viewModel = CompetitionsViewModel()
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ForEach(viewModel.competitions) { competition in
                    NavigationLink {
                        CompetitionDetailView(competition: competition)
                    } label: {
                        CompetitionRow(competition: competition)
                    }
                }
            }
        }
        .navigationTitle("Competitions")
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
}

struct CompetitionRow: View {
    let competition: Competition
    
    var body: some View {
        HStack {
            if let emblemUrl = competition.emblem {
                AsyncImage(url: URL(string: emblemUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "sportscourt.fill")
                }
                .frame(width: 40, height: 40)
            } else {
                Image(systemName: "sportscourt.fill")
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(competition.name)
                    .font(.headline)
                if let area = competition.area {
                    Text(area.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CompetitionsView()
} 
