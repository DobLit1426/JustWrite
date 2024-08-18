//
//  TextContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct TextContentBlock: ContentBlock {
    var type: ContentBlockType { .text(size: textSize) }
    var textSize: TextSize
    
    var content: String
    
    init(textSize: TextSize, content: String) {
        self.textSize = textSize
        self.content = content
    }
}

//struct H1ContentBlock: ContentBlock {
//    static func == (lhs: H1ContentBlock, rhs: H1ContentBlock) -> Bool {
//        lhs.content == rhs.content
//    }
//    
//    let type: ContentBlockType = .text(size: .h1)
//    var content: String
//    
//    init(content: String) {
//        self.content = content
//    }
//}
