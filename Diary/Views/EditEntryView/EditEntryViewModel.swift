//
//  EditEntryViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 14.08.24.
//

import Foundation
import UIKit
import SwiftUI

//enum ChangeType<ContentType: Equatable>: Equatable {
//    case newBlock
//    case contentChanged(ContentType)
//    case removedBlock
//}
//
//class ContentBlockChange<ContentType: Equatable>: Identifiable, Equatable {
//    static func == (lhs: ContentBlockChange, rhs: ContentBlockChange) -> Bool {
//        return (lhs.id == rhs.id) && (lhs.changeType == rhs.changeType)
//    }
//    
//    let id: UUID
//    var changeType: ChangeType<ContentType>
//    
//    init(id: UUID, changeType: ChangeType<ContentType>) {
//        self.id = id
//        self.changeType = changeType
//    }
//}



// Logic:
// 1. On the appear, the diaryEntry is saved into a local variable
// 2. The real diary entry (in SwiftData) is updated only occasionally

//class EditEntryViewModel: ObservableObject {
//    // MARK: - Logger
//    let logger = AppLogger(category: "EditEntryViewModel")
//    
//    // MARK: - @Published variables
//    @Published var cachedEntry: DiaryEntry = DiaryEntry()
//    
//    // MARK: - Computed variables
//    var datePickerStartingDate: Date {
//        Calendar.current.date(byAdding: .year, value: -100, to: Date())!
//    }
//    
//    // MARK: - Init
//    init() {
//        logger.initBegin()
//        
//        logger.initEnd()
//    }
//    
//    // MARK: - Public functions
//    func updateOnAppear(with diaryEntry: DiaryEntry) {
//        // Assign the content blocks
//        self.cachedEntry = diaryEntry
//        
//        // Fill textBlockCachedContent with existing strings and fill blocksLastUpdateTime
////        let now = Date.now
////        
////        contentBlocks.forEach { contentBlock in
////            if let textContentBlock = contentBlock as? TextContentBlock {
////                textBlockCachedContent[textContentBlock.id] = (textContentBlock.content, textContentBlock.textSize)
////                textBlocksLastUpdateTime[textContentBlock.id] = now
////            }
////        }
//    }
//    
//    func getBlock(with id: UUID) -> (any ContentBlock)? {
//        return cachedEntry.content.first { $0.id == id }
//    }
    
    
    
    
//    func updatedBlock(with blockId: UUID, dateOfUpdate: Date = .now) {
//        blocksLastUpdateTime[blockId] = dateOfUpdate
//    }
//    
//    func shouldFetchBlockFromSwiftData(with blockId: UUID) -> Bool {
//        if let updateTime = blocksLastUpdateTime[blockId], updateTime.timeIntervalSinceNow > 5 {
//            return false
//        }
//        
//        return true
//    }
//}

//class EditEntryViewModel: ObservableObject {
//    // MARK: - Logger
//    let logger = AppLogger(category: "EditEntryViewModel")
//    
//    // MARK: - @Published variables
//    @Published var blocksLastUpdateTime: [UUID: Date] = [:]
//    
//    @Pub
//    @Published var contentBlocks: [any ContentBlock] = []
//    
//    // MARK: - Init
//    
//    // MARK: - Public functions
//    func updateOnAppear(with diaryEntry: DiaryEntry) {
//        
//    }
//    
//    func updatedBlock(with blockId: UUID, dateOfUpdate: Date = .now) {
//        blocksLastUpdateTime[blockId] = dateOfUpdate
//    }
//    
//    func shouldFetchBlockFromSwiftData(with blockId: UUID) -> Bool {
//        if let updateTime = blocksLastUpdateTime[blockId], updateTime.timeIntervalSinceNow > 5 {
//            return false
//        }
//        
//        return true
//    }
//}
