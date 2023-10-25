//
//  DestructiveButton.swift
//  Diary
//
//  Created by Dobromir Litvinov on 20.10.2023.
//

import SwiftUI

/// Button that represents a destructive action
struct DestructiveButton: View {
    //MARK: - Properties
    /// The button title
    let title: String
    
    /// The button action
    let action: () -> Void
    
    //MARK: - Init
    /// Initialise button with title and action
    init(_ title: String, _ action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    //MARK: - Body
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
        }
        .foregroundStyle(.red)
    }
}

#Preview {
    List {
        DestructiveButton("Action 1") {
            print("A destructive button was pressed")
        }
        DestructiveButton("Action 2") {
            print("A destructive button was pressed")
        }
        DestructiveButton("Action 3") {
            print("A destructive button was pressed")
        }
    }
}
