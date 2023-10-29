//
//  SearchResults.swift
//  Diary
//
//  Created by Dobromir Litvinov on 29.10.2023.
//

import SwiftUI
import SwiftData

struct EntriesSearchResults: View {
    @Query private var entries: [DiaryEntry]
    @State var filteredEntries: [DiaryEntry]?
    let promt: String
    
    init(promt: String) {
        self.promt = promt
    }
    
    var body: some View {
        Group {
            if let filteredEntries {
                if filteredEntries.isEmpty {
                    Text("No search results for \(promt)")
                } else {
                    List(filteredEntries) { entry in
                        NavigationLink {
                            EditExistingDiaryEntryView(diaryEntry: entry)
                        } label: {
                            EntriesListRow(entry: entry)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.filteredEntries = entries.filter({ entry in
                let promtTextInHeading: Bool = entry.heading.contains(promt)
                let promtTextInContent: Bool = entry.content.contains(promt)
                
                let includeEntryInSearchResults: Bool = promtTextInHeading || promtTextInContent
                return includeEntryInSearchResults
            })
        }
    }
}

#Preview {
    EntriesSearchResults(promt: "Test")
}
