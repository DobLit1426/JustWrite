//
//  ImagesContentBlockView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.08.24.
//

import SwiftUI

struct ImagesContentBlockView: View, Equatable {
    // MARK: - Logger
    private let logger = AppLogger(category: "ImagesContentBlockView")
    
    // MARK: - Constants
    let imagesData: [Data]
    let id: UUID
    
    // MARK: - Init
    init(_ imagesContentBlock: ImagesContentBlock) {
        logger.initBegin()
        
        self.imagesData = imagesContentBlock.content
        self.id = imagesContentBlock.id
        
        logger.initEnd()
    }
    
    // MARK: - Body
    var body: some View {
        LazyVStack {
            ForEach(imagesData.indices, id: \.self) { index in
                EquatableView(content:
                    LazyImage(from: imagesData[index], blockId: id, indexInBlock: index)
                )
            }
        }
    }
    
    static func == (lhs: ImagesContentBlockView, rhs: ImagesContentBlockView) -> Bool {
        (lhs.id == rhs.id) && (lhs.imagesData == rhs.imagesData)
    }
}

#Preview {
    ImagesContentBlockView(ImagesContentBlock(content: [Data.init(repeating: UInt8(10), count: 1000)]))
}
