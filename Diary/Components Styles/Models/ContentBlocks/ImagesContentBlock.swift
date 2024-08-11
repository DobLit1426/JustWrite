//
//  ImageContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct ImagesContentBlock: ContentBlock {
    private(set) var type: ContentBlockType = .image
    
    var content: [Data]
    var id: UUID
    
    init(content: [Data], id: UUID = UUID()) {
        self.content = content
        self.id = id
    }
}
