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
final class DiaryEntry: Encodable, Decodable, Identifiable {
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
    
    /// Initialises a diary entry object from a JSON String. If fails, returns nil.
    /// - Parameter jsonString: The JSON String of DiaryEntry
    init?(from jsonString: String) {
        logger.info("Starting initialising DiaryEntry from JSON")
        
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            logger.error("Couldn't convert JSON string to Data, returning nil")
            return nil
        }
        
        guard let entry = try? decoder.decode(DiaryEntry.self, from: jsonData) else {
            logger.error("Couldn't decode JSON Data to DiaryEntry, returning nil")
            return nil
        }
        
        self.heading = entry.heading
        self.content = entry.content
        self.id = entry.id
        self.date = entry.date
        
        logger.info("Successfully initialised DiaryEntry from JSON")
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heading = try container.decode(String.self, forKey: .heading)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        date = try container.decode(Date.self, forKey: .date)
    }
    // MARK: - Public functions
    
    /// Generates JSON of the current diary entry
    /// - Returns: If successfull, JSON String, otherwise nil
    public func generate_json() -> String? {
        logger.info("Started generating JSON for DiaryEntry with id '\(self.id, privacy: .private)'")
        let encoder = JSONEncoder()
        
        guard let json = try? encoder.encode(self) else {
            logger.error("Couldn't encode DiaryEntry with id '\(self.id, privacy: .private)', returning nil")
            return nil
        }
        
        guard let jsonAsString = String(data: json, encoding: .utf8) else {
            logger.error("Couldn't convert the JSON data of DiaryEntry with id '\(self.id, privacy: .private)' to String, returning nil")
            return nil
        }
        
        logger.info("Successfully generated JSON for DiaryEntry with id '\(self.id, privacy: .private)'")
        return jsonAsString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(heading, forKey: .heading)
        try container.encode(content, forKey: .content)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
    }
    
    /// CodingKeys used for encoding and decoding DiaryEntry using JSON
    private enum CodingKeys: String, CodingKey {
        case heading
        case content
        case id
        case date
    }
}
