//
//  TextContentBlockView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.08.24.
//

import SwiftUI

fileprivate struct LocalizedStrings {
    static let contentTextFieldPlaceholder = String(localized: "TextField TextContentBlockView placeholder", defaultValue: "Write something here", comment: "This text is used as the placeholder for the TextField for the TextContentBlockView")
}

struct TextContentBlockView: View, Equatable {
    // MARK: - Logger
    private let logger = AppLogger(category: "TextContentBlockView")
    
    // MARK: - Public constants
    let textSize: TextSize
    
    // MARK: - @Binding variables
    @Binding var text: String
    
    // MARK: - Body
    var body: some View {
        TextField(
            LocalizedStrings.contentTextFieldPlaceholder,
            text: $text,
            axis: .vertical
        )
        .lineLimit(nil)
        .font(textFont(for: textSize))
    }
    
    // MARK: - Private functions
    private func textFont(for textSize: TextSize) -> Font {
        let functionName = "textFont(for textSize: TextSize) -> Font"
        logger.functionBegin(functionName)
        logger.functionEnd(functionName)
        
        switch textSize {
        case .h1: 
            return .title
        case .h2: 
            return .title2
        case .h3: 
            return .title3
        }
    }
    
    // MARK: - Static functions
    static func == (lhs: TextContentBlockView, rhs: TextContentBlockView) -> Bool {
        (lhs.textSize == rhs.textSize) && (lhs.text == rhs.text)
    }
}

#Preview {
    TextContentBlockView(textSize: .h1, text: .constant("This is a sample text"))
}
