//
//  TextContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct TextContentBlock: ContentBlock {
    var type: ContentBlockType { .text(size: textSize) }
    var content: String
    var id: UUID
    
    var textSize: TextSize
    
    
    init(textSize: TextSize, content: String, id: UUID = UUID()) {
        self.textSize = textSize
        self.content = content
        self.id = id
    }
}
