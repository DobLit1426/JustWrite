//
//  DiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import Foundation
import SwiftData
import os

public final class ContentBlockLinkedIndexedEntity: Identifiable, Codable {
    public let id: UUID
    var index: Int
    
    init(id: UUID, index: Int) {
        self.id = id
        self.index = index
    }
}



/// Represents a single diary entry
@Model
final class DiaryEntry: Entry, CustomDebugStringConvertible {
    /// Logger instance
    @Transient private var logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryEntry")
    
    // MARK: - Properties
    /// The heading of the diary entry
    var heading: String
    
    /// The content (body) of the diary entry
//    var content: [ContentBlockWrapper]
    
    /// The ID of the diary entry
    @Attribute(.unique) var id: UUID
    
    /// The date of the diary entry
    var date: Date
    
    /// The public available mood of the diary entry
    /// - Important: It's value must be in the range of -1 to 1
    var mood: Double?
    
    var contentBlocksOrder: [ContentBlockLinkedIndexedEntity]
    
    var textContentBlocks: [TextContentBlock]
    var imagesContentBlocks: [ImagesContentBlock]
    var dividerContentBlocks: [DividerContentBlock]
    
    // MARK: - Computed properites
    /// Mixed and unordered content blocks of the diary entry content
    var allContentBlocks: [any ContentBlock] {
        var result: [any ContentBlock] = []
        
        result.append(contentsOf: textContentBlocks)
        result.append(contentsOf: imagesContentBlocks)
        result.append(contentsOf: dividerContentBlocks)
        
        return result
    }
    
    /// The formatted date of the diary entry
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let formattedString = formatter.string(for: date)
        return formattedString ?? String(date.formatted())
    }
    
    /// The ordered content blocks that make up the content of the diary entry
    var content: [any ContentBlock] {
        get {
            let result = allContentBlocks.sorted { contentBlock1, contentBlock2 in
                if let linkedIndexedEntity1 = contentBlocksOrder.first(where: { $0.id == contentBlock1.id }), let linkedIndexedEntity2 = contentBlocksOrder.first(where: { $0.id == contentBlock2.id }) {
                    return linkedIndexedEntity1.index < linkedIndexedEntity2.index
                }
                return false
            }
            
            return result
        }
        set {
            textContentBlocks = []
            imagesContentBlocks = []
            dividerContentBlocks = []
            contentBlocksOrder = []
            
            for contentBlock in newValue {
                appendNewBlock(contentBlock)
            }
        }
    }
    
    /// Textual representation for debugging purposes
    var debugDescription: String {
        return "DiaryEntry(heading: \(heading), content: \(content), mood: \(String(describing: mood)), date: \(date), id: \(id)"
    }
    
    var allEntryTextInSingleString: String {
        var result: String = ""
        // TODO: Write the allEntryTextInSingleString
//        for blockWrapper in content {
//            switch blockWrapper {
//            case .textBlock(let textContentBlock):
//                result += textContentBlock.content + "\n"
//            default: continue
//            }
//        }
        
        return result
    }
    
    // MARK: - Inits
    
    /// Initialises a diary entry
    /// - Parameters:
    ///   - heading: The heading of the diary entry
    ///   - content: The content blocks, which make up the diary entry content
    ///   - mood: The mood of the diary entry
    ///   - date: The date of the diary entry
    ///   - id: The id of the diary entry
    init(heading: String, content: [any ContentBlock] = [], mood: Double? = nil, date: Date = Date(), id: UUID = UUID()) {
        logger.info("Starting to initialise DiaryEntry")
        
        self.contentBlocksOrder = []
        self.textContentBlocks = []
        self.imagesContentBlocks = []
        self.dividerContentBlocks = []
        
        self.heading = heading
        self.id = id
        self.date = date
        self.mood = mood
        
        self.content = content
        
        logger.info("Successfully initialised DiaryEntry")
    }
    
    
    /// Initialises an empty diary entry with empty heading and content, current date, mood that is set to nil and a random id using UUID()
    init() {
        logger.info("Starting to initialise empty DiaryEntry")
        
        self.contentBlocksOrder = []
        self.textContentBlocks = []
        self.imagesContentBlocks = []
        self.dividerContentBlocks = []
        
        self.heading = ""
        self.id = UUID()
        self.date = Date()
        self.mood = nil
        
        logger.info("Successfully initialised empty DiaryEntry")
    }
    
    // MARK: - Public functions
    public func appendNewBlock(_ contentBlock: any ContentBlock) {
        if let textContentBlock = contentBlock as? TextContentBlock {
            textContentBlocks.append(textContentBlock)
        } else if let imagesContentBlock = contentBlock as? ImagesContentBlock {
            imagesContentBlocks.append(imagesContentBlock)
        } else if let dividerContentBlock = contentBlock as? DividerContentBlock {
            dividerContentBlocks.append(dividerContentBlock)
        } else {
            logger.critical("Couldn't determine the type of the content block")
        }
        
        let newIndexedEntityIndex: Int = allContentBlocks.count
        let indexedEntity = ContentBlockLinkedIndexedEntity(id: contentBlock.id, index: newIndexedEntityIndex)
        
        contentBlocksOrder.append(indexedEntity)
    }
}
