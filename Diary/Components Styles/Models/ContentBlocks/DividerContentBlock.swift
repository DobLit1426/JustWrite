//
//  DividerContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct DividerContentBlock: ContentBlock {
    let type: ContentBlockType = .divider
    var content: DividerType
    
    init(content: DividerType) {
        self.content = content
    }
}
