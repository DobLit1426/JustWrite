//
//  SquareFrame.swift
//  Diary
//
//  Created by Dobromir Litvinov on 23.08.24.
//

import SwiftUI

struct SquareFrame<T: View>: View {
    private let rectangle = RoundedRectangle(cornerRadius: 15)
    
    var content: T
    
    init(content: @escaping () -> T) {
        self.content = content()
    }
    
    var body: some View {
        rectangle
            .aspectRatio(1, contentMode: .fill)
            .overlay(
                content
                    .scaledToFill()
            )
            .clipShape(rectangle)
    }
}

#Preview {
    SquareFrame {
        ForEach(0..<100, id: \.self) { index in
            Text("\(index). This is a really long text.")
        }
    }
}
