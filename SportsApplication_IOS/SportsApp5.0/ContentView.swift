//
//  ContentView.swift
//  SportsApp5.0
//
//  Created by Ali Taha on 11/17/24.
//

import SwiftUI
import ParseSwift

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                NavigationStack {
                    CompetitionsView()
                }
                .tabItem {
                    Label("Competitions", systemImage: "trophy.fill")
                }
                    
                NavigationStack {
                    ProfileView(authViewModel: authViewModel)
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
        } else {
            LoginView(authViewModel: authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
