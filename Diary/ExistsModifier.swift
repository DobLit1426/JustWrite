//
//  ShowIf.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.11.2023.
//

import Foundation
import SwiftUI

struct ExistsModifier: ViewModifier {
    let exists: Bool
    
    init(existsIf exists: Bool) {
        self.exists = exists
    }
    
    func body(content: Content) -> some View {
        if exists {
            content
        } else {
            EmptyView()
        }
    }
}
