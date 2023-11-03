//
//  DiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import Foundation
import SwiftData
import os

/// Represents a single diary entry
@Model
final class DiaryEntry: Identifiable {
    /// Logger instance
    @Transient private var logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryEntry")
    
    // MARK: - Properties
    /// The heading of the diary entry
    var heading: String
    
    /// The content (body) of the diary entry
    var content: String
    
    /// The ID of the diary entry
    var id: UUID
    
    /// The date of the diary entry
    var date: Date
    
    // MARK: - Computed properites
    /// The formatted date of the diary entry
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedString = formatter.string(for: date)
        return formattedString ?? String(date.formatted())
    }
    
    /// Textual representation for debugging purposes
    var description: String {
        return "DiaryEntry(heading: \(heading), content: \(content), date: \(date), id: \(id))"
    }
    
    // MARK: - Inits
    /// Initialises the diary entry object by setting the properties to the provided parameters
    /// - Parameters:
    ///   - heading: The heading of the diary entry
    ///   - content: The content (body) of the diary entry
    ///   - date: The ID of the diary entry, by default current date
    ///   - id: The date of the diary entry, by default UUID()
    init(heading: String, content: String, date: Date = Date(), id: UUID = UUID()) {
        logger.info("Starting to initialise DiaryEntry")
        
        self.heading = heading
        self.content = content
        self.id = id
        self.date = date
        
        logger.info("Successfully initialised DiaryEntry")
    }
    
    /// Initialises an empty diary entry with empty heading and content, current date and a random id using UUID()
    init() {
        logger.info("Starting to initialise empty DiaryEntry")
        
        self.heading = ""
        self.content = ""
        self.id = UUID()
        self.date = Date()
        
        logger.info("Successfully initialised empty DiaryEntry")
    }
}
