//
//  DividerContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct DividerContentBlock: ContentBlock {
//    private(set) var type: ContentBlockType = .divider
    var content: DividerType
    var id: UUID
    
    init(content: DividerType, id: UUID = UUID()) {
        self.content = content
        self.id = id
    }
}
