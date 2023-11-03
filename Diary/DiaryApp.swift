//
//  DiaryApp.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import SwiftData

@main
/// Main struct responisble for launching and setting up the app
struct DiaryApp: App {
    // MARK: - Logger
    /// Logger instance
    private let logger = AppLogger(category: "DiaryApp")
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            FirstView()
        }
        .modelContainer(for: [DiaryEntry.self, Settings.self])
    }
}
