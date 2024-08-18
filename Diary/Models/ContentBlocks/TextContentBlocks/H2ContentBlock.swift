//
//  H2ContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct H2ContentBlock: ContentBlock {
    let type: ContentBlockType = .text(size: .h2)
    var content: String
    
    init(content: String) {
        self.content = content
    }
}
