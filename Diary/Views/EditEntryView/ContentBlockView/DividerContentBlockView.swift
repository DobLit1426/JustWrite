//
//  DividerContentBlockView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.08.24.
//

import SwiftUI

struct DividerContentBlockView: View, Equatable {
    // MARK: - Logger
    private let logger = AppLogger(category: "DividerContentBlockView")
    
    // MARK: - Private constants
    private let dividerType: DividerType
    
    // MARK: - Init
    init(_ dividerContentBlock: DividerContentBlock) {
        logger.initBegin()
        
        self.dividerType = dividerContentBlock.content
        
        logger.initEnd()
    }
    
    // MARK: - Body
    var body: some View {
        Divider()
            .frame(height: dividerType == DividerType.thick ? 3 : 1)
            .overlay(Color.black)
    }
}

#Preview {
    DividerContentBlockView(DividerContentBlock(content: .thick))
}
