//
//  LockSymbol.swift
//  Diary
//
//  Created by Dobromir Litvinov on 21.10.2023.
//

import SwiftUI

/// Use to display that the app is locked
struct LockSymbol: View {
    //MARK: - @Environment variables
    /// System color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    //MARK: - Body
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                .frame(width: 100)
            Image(systemName: "lock.fill")
                .font(.system(size: 50))
                .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                .symbolEffect(.pulse, isActive: true)
        }
    }
}

#Preview {
    LockSymbol()
        .preferredColorScheme(.light)
}

#Preview {
    LockSymbol()
        .preferredColorScheme(.dark)
}
