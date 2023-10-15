//
//  DiaryApp.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import SwiftData
import os

@main
/// Main struct responisble for launching and setting up the app
struct DiaryApp: App {
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryApp")
    
    var body: some Scene {
        WindowGroup {
            FirstView()
        }
        .modelContainer(for: [EncryptedDiaryEntry.self, Settings.self])
    }
}