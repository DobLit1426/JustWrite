//
//  DiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import Foundation
import os

final class DiaryEntry: Encodable, Decodable, Identifiable {
    private var logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryEntry")
    
    var heading: String
    var content: String
    var id: UUID
    var date: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let formattedString = formatter.string(for: date)
        return formattedString ?? String(date.formatted())
    }
    
    init(heading: String, content: String, date: Date = Date(), id: UUID = UUID()) {
        self.heading = heading
        self.content = content
        self.id = id
        self.date = date
        
        logger.info("Successfully initialised DiaryEntry object")
    }
    
    init() {
        self.heading = ""
        self.content = ""
        self.id = UUID()
        self.date = Date()
        
        logger.info("Successfully initialised empty DiaryEntry object")
    }
    
    func print_in_console() {
        print("Heading: \(self.heading)")
        print("Date: \(self.date)")
        print("ID: \(self.id)")
        print(self.content)
    }
    
    func generate_json() -> String? {
        logger.info("Started generating JSON for the diary entry with id '\(self.id, privacy: .private)'")
        let encoder = JSONEncoder()
        
        guard let json = try? encoder.encode(self) else {
            logger.error("Couldn't encode the diary entry with id '\(self.id, privacy: .private)'")
            return nil
        }
        
        guard let jsonAsString = String(data: json, encoding: .utf8) else {
            logger.error("Couldn't convert the JSON data of the diary entry with id '\(self.id, privacy: .private)' to String")
            return nil
        }
        
        logger.info("Successfully generated JSON for the diary entry with id '\(self.id, privacy: .private)'")
        return jsonAsString
    }
    
    init?(from jsonString: String) {
        logger.info("Starting initialising DiaryEntry object from JSON")
        
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            logger.error("Couldn't convert JSON string to Data")
            return nil
        }
        
        guard let entry = try? decoder.decode(DiaryEntry.self, from: jsonData) else {
            logger.error("Couldn't decode JSON Data to DiaryEntry object")
            return nil
        }
        
        self.heading = entry.heading
        self.content = entry.content
        self.id = entry.id
        self.date = entry.date
        
        logger.info("Successfully initialised DiaryEntry object from JSON")
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(heading, forKey: .heading)
        try container.encode(content, forKey: .content)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heading = try container.decode(String.self, forKey: .heading)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    private enum CodingKeys: String, CodingKey {
        case heading
        case content
        case id
        case date
    }
}
