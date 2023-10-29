//
//  EntriesListRow.swift
//  Diary
//
//  Created by Dobromir Litvinov on 29.10.2023.
//

import SwiftUI

struct EntriesListRow: View {
    let entry: DiaryEntry
    
    init(entry: DiaryEntry) {
        self.entry = entry
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.heading)
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text(entry.formattedDate)
                    .font(.subheadline)
                Spacer()
            }
        }
    }
}

#Preview {
    EntriesListRow(entry: DiaryEntry(heading: "Heading", content: "Content"))
}
