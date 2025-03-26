//
//  SportsApp5_0App.swift
//  SportsApp5.0
//
//  Created by Ali Taha on 11/17/24.
//

import SwiftUI
import ParseSwift

@main
struct SportsApp5_0App: App {
    init() {
        let configuration = ParseConfiguration(
            applicationId: "",
            clientKey: "",
            serverURL: URL(string: "https://parseapi.back4app.com")!
        )
        ParseSwift.initialize(configuration: configuration)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
