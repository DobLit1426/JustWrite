//
//  TestView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation
import SwiftData
import SwiftUI

struct TestView: View {
    @Query var entries: [DiaryEntry]
    
    var body: some View {
        VStack {
            ForEach(entries) { entry in
                Text(entry.heading)
            }
        }
    }
}


#Preview {
    TestView()
}
