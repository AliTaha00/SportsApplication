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
            applicationId: "KuZevi7cG6b7ERH2RrlhB1I4MShFFwSOKAgzzCN4",
            clientKey: "v9ZOzUlG0ddQA9rkWmk2uMo8F5B12o6Y6a2EHgXy",
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
