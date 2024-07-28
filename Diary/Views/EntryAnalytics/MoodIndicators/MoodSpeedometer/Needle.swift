//
//  Needle.swift
//  Diary
//
//  Created by Dobromir Litvinov on 22.11.2023.
//

import SwiftUI

struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 35, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

#Preview {
    Needle()
}
