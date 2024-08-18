//
//  SwiftDataTest.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.08.24.
//

import Foundation
import SwiftData

//fileprivate class ContentBlockEntity {
//    let id: UUID
//
//    init(id: UUID = UUID()) {
//        self.id = id
//    }
//}
//
//fileprivate class TextBlock: ContentBlockEntity {
//    let content: String
//
//    init(content: String, id: UUID = UUID()) {
//        self.content = content
//        super.init(id: id)
//    }
//}
//
//fileprivate class DividerBlock: ContentBlockEntity {
//    let type: DividerType
//
//    init(type: DividerType, id: UUID = UUID()) {
//        self.type = type
//        super.init(id: id)
//    }
//}

//@Model
//final fileprivate class Test {
//    var text: String
//    
//    var contentBlocksOrder: [ContentBlockLinkedIndexedEntity]
//    
//    var textContentBlocks: [TextContentBlock]
//    var imagesContentBlocks: [ImagesContentBlock]
//    var dividerContentBlocks: [DividerContentBlock]
//    
//    var orderedContent: [any ContentBlock] {
//        var allBlocksMixed = [any ContentBlock]()
//        
//        allBlocksMixed.append(contentsOf: textContentBlocks)
//        allBlocksMixed.append(contentsOf: imagesContentBlocks)
//        allBlocksMixed.append(contentsOf: dividerContentBlocks)
//        
//        
//        var result = [any ContentBlock]()
//        
//        contentBlocksOrder.forEach { indexedEntity in
//            <#code#>
//        }
//        
////        let result = allBlocksMixed.sorted { contentBlock1, contentBlock2 in
////            if let indexOfEntity1 = contentBlocksOrder.firstIndex(where: { $0.id == contentBlock1.id }), let indexOfEntity2 = contentBlocksOrder.first(where: { $0.id == contentBlock2.id }) {
////                return indexOfEntity1 < indexOfEntity2
////            }
////            return false
////        }
//        
//        return result
//    }
//    
//    init(text: String, contentBlocksOrder: [ContentBlockLinkedIndexedEntity], textContentBlocks: [TextContentBlock], imagesContentBlocks: [ImagesContentBlock], dividerContentBlocks: [DividerContentBlock]) {
//        self.text = text
//        self.contentBlocksOrder = contentBlocksOrder
//        self.textContentBlocks = textContentBlocks
//        self.imagesContentBlocks = imagesContentBlocks
//        self.dividerContentBlocks = dividerContentBlocks
//    }
//    
//    init() {
//        self.text = ""
//        self.contentBlocksOrder = []
//        self.imagesContentBlocks = []
//        self.dividerContentBlocks = []
//        self.textContentBlocks = []
//    }
//}
