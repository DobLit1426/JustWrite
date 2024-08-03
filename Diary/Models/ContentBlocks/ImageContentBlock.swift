//
//  ImageContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct ImageContentBlock: ContentBlock {
    let type: ContentBlockType = .image
    var content: Data
    
    init(content: Data) {
        self.content = content
    }
}
