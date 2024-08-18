//
//  ImageContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

struct ImagesContentBlock: ContentBlock {
//    private(set) var type: ContentBlockType = .image
    
    /// The images block stores the IDs of the images, because the images are stored separately in order to implement the caching function
    
    var content: [Data]
    var id: UUID
    
    init(content: [Data], id: UUID = UUID()) {
        self.content = content
        self.id = id
    }
}
