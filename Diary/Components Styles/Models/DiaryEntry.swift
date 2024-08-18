//
//  DiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import Foundation
import SwiftData
import os

public final class ContentBlockLinkedIndexedEntity: Identifiable, Codable, Equatable {
    public static func == (lhs: ContentBlockLinkedIndexedEntity, rhs: ContentBlockLinkedIndexedEntity) -> Bool {
        (lhs.id == rhs.id) && (lhs.type == rhs.type)
    }
    
    public let id: UUID
    public let type: ContentBlockType
    
    init(id: UUID, type: ContentBlockType) {
        self.id = id
        self.type = type
    }
}

/// Represents a single diary entry
@Model
final class DiaryEntry: Entry, CustomDebugStringConvertible {
    // MARK: - Logger
    /// Logger instance
    @Transient private var logger: AppLogger = AppLogger(category: "DiaryEntry")
    
    // MARK: - Properties
    /// The heading of the diary entry
    var heading: String
    
    /// The ID of the diary entry
    @Attribute(.unique) var id: UUID
    
    /// The date of the diary entry
    var date: Date
    
    /// The public available mood of the diary entry
    /// - Important: It's value must be in the range of -1 to 1
    var mood: Double?
    
    var indexedEntities: [ContentBlockLinkedIndexedEntity]
    
    var textContentBlocks: [TextContentBlock]
    @Attribute(.externalStorage) var imagesContentBlocks: [ImagesContentBlock]
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
            let result: [any ContentBlock] = indexedEntities.compactMap { indexedEntity in
                if let contentBlock = allContentBlocks.first(where: { $0.id == indexedEntity.id }) {
                    return contentBlock
                } else {
                    return nil
                }
            }
            
            return result
        }
        set {
            textContentBlocks = []
            imagesContentBlocks = []
            dividerContentBlocks = []
            indexedEntities = []
            
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
        logger.initBegin()
        
        self.indexedEntities = []
        self.textContentBlocks = []
        self.imagesContentBlocks = []
        self.dividerContentBlocks = []
        
        self.heading = heading
        self.id = id
        self.date = date
        self.mood = mood
        
        self.content = content
        
        logger.initEnd()
    }
    
    
    /// Initialises an empty diary entry with empty heading and content, current date, mood that is set to nil and a random id using UUID()
    init() {
        logger.initBegin()
        
        self.indexedEntities = []
        self.textContentBlocks = []
        self.imagesContentBlocks = []
        self.dividerContentBlocks = []
        
        self.heading = ""
        self.id = UUID()
        self.date = Date()
        self.mood = nil
        
        logger.initEnd()
    }
    
    // MARK: - Public functions
    public func appendNewBlock(_ contentBlock: any ContentBlock, addIndexedEntity: Bool = true) {
        let functionName = "appendNewBlock"
        logger.functionBegin(functionName)
        
        let contentBlockType: ContentBlockType
        
        if let textContentBlock = contentBlock as? TextContentBlock {
            textContentBlocks.append(textContentBlock)
            contentBlockType = .text
        } else if let imagesContentBlock = contentBlock as? ImagesContentBlock {
            imagesContentBlocks.append(imagesContentBlock)
            contentBlockType = .image
        } else if let dividerContentBlock = contentBlock as? DividerContentBlock {
            dividerContentBlocks.append(dividerContentBlock)
            contentBlockType = .divider
        } else {
            logger.error("Couldn't determine the type of the content block")
            logger.functionEnd(functionName, successfull: false)
            return
        }
        
        if addIndexedEntity {
            let indexedEntity = ContentBlockLinkedIndexedEntity(id: contentBlock.id, type: contentBlockType)
            indexedEntities.append(indexedEntity)
            logger.info("Appended indexed entity with id '\(contentBlock.id)'")
        }
        
        logger.functionEnd(functionName)
    }
    
    public func appendNewBlocks(_ contentBlocks: [any ContentBlock]) {
        logger.functionBegin("appendNewBlocks")
        
        for block in contentBlocks {
            appendNewBlock(block)
        }
        
        logger.functionEnd("appendNewBlocks")
    }
    
    public func removeBlock(at index: Int, removeLinkedIndexedEntity: Bool = true) {
        let functionName = "removeBlock(at index: Int, removeLinkedIndexedEntity: Bool = true)"
        logger.functionBegin(functionName)
        
        guard indexedEntities.indices.contains(index) else {
            logger.critical("Attempt to remove block at index \(index) that is out of range")
            logger.functionEnd(functionName, successfull: false)
            return
        }
        
        let blockId = indexedEntities[index].id
        removeBlock(with: blockId, removeLinkedIndexedEntity: removeLinkedIndexedEntity)
        
        logger.functionEnd(functionName)
    }
    
    public func removeBlock(with id: UUID, removeLinkedIndexedEntity: Bool = true) {
        let functionName = "removeBlock(with id: UUID, removeLinkedIndexedEntity: Bool = true)"
        logger.functionBegin(functionName)
        
        if removeLinkedIndexedEntity {
            guard indexedEntities.contains(where: { $0.id == id }) else {
                logger.critical("Attempt to remove block with id \(id) that doesn't exist")
                logger.functionEnd(functionName, successfull: false)
                return
            }
        }
        
        var allBlocksSnap = allContentBlocks
        allBlocksSnap.removeAll { $0.id == id }
        
        self.content = allBlocksSnap
        
        if removeLinkedIndexedEntity {
            indexedEntities.removeAll { $0.id == id }
        }
        
        logger.functionEnd(functionName)
    }
    
//    public func getBlock(with id: UUID) -> (any ContentBlock)? {
//        let functionName = "getBlock(with id: UUID)"
//        logger.functionBegin(functionName)
//        
////        guard indexedEntities.contains(where: { $0.id == id }) else {
////            logger.critical("The indexed entity with id '\(id)' doesn't exist")
////            logger.functionEnd(functionName, successfull: false)
////            return nil
////        }
//        
//        let block: (any ContentBlock)? = allContentBlocks.first(where: { $0.id == id })
//        
//        logger.functionEnd(functionName)
//        
//        return block
//    }
    
    public func getBlock(for indexedEntity: ContentBlockLinkedIndexedEntity) -> (any ContentBlock)? {
        let functionName = "getBlock(for indexedEntity: ContentBlockLinkedIndexedEntity)"
        logger.functionBegin(functionName)
        
//        guard indexedEntities.contains(where: { $0.id == indexedEntity.id }) else {
//            logger.critical("The provided indexed entity with id '\(indexedEntity.id)' doesn't exist")
//            logger.functionEnd(functionName, successfull: false)
//            return nil
//        }
        
        let contentBlock: (any ContentBlock)?
        
        switch indexedEntity.type {
        case .text:
            contentBlock = textContentBlocks.first(where: { $0.id == indexedEntity.id })
        case .image:
            contentBlock = imagesContentBlocks.first(where: { $0.id == indexedEntity.id })
        case .divider:
            contentBlock = dividerContentBlocks.first(where: { $0.id == indexedEntity.id })
        }
        
        guard let contentBlock = contentBlock else {
            logger.critical("The asked content block with id '\(indexedEntity.id)' doesn't exist")
            logger.functionEnd(functionName, successfull: false)
            return nil
        }
        
        logger.functionEnd(functionName)
        return contentBlock
    }
    
    public func blockExists(with id: UUID) -> Bool {
        return content.contains(where: { $0.id == id })
    }
    
//    public func updateBlock(with newBlock: any ContentBlock) {
//        let functionName = "updateBlock(with newBlock: any ContentBlock)"
//        logger.functionBegin(functionName)
//        
//        let id = newBlock.id
//        
//        guard let blockNow = getBlock(with: id) else {
//            logger.critical("Couldn't find the existing block with the id \(id)")
//            logger.functionEnd(functionName, successfull: false)
//            return
//        }
//        
//        if type(of: blockNow) != type(of: newBlock) {
//            logger.critical("The type of the new block isn't the same as of the current block (with id '\(id)')")
//        }
//        
//        removeBlock(with: id, removeLinkedIndexedEntity: false)
//        appendNewBlock(newBlock, addIndexedEntity: false)
//    }
    
    public func updateTextBlock(id: UUID, newText: String?, newTextSize: TextSize? = nil) {
        let functionName = "updateTextBlock(with text: String, textSize: TextSize)"
        logger.functionBegin(functionName)
        
        guard let blockIndex = textContentBlocks.firstIndex(where: { $0.id == id }) else {
            logger.critical("Couldn't find the block index with id '\(id)'")
            logger.functionEnd(functionName, successfull: false)
            return
        }
        
        if let text = newText {
            textContentBlocks[blockIndex].content = text
        }
        
        if let textSize = newTextSize {
            textContentBlocks[blockIndex].textSize = textSize
        }
        
        logger.functionEnd(functionName)
    }
}
