//
//  H3ContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct H3ContentBlock: ContentBlock {
    let type: ContentBlockType = .text(size: .h3)
    var content: String
    
    init(content: String) {
        self.content = content
    }
}
