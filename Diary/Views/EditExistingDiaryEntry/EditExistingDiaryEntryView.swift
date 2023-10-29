//
//  EditExistingDiaryEntryView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData

fileprivate class EditExistingDiaryEntryViewLocalizedStrings {
    static let diaryHeadingTextFieldPlaceholder: String = String(localized: "Heading of the diary entry", defaultValue: "Heading of the diary entry", comment: "This text is used as a TextField placeholder where the diary entry should be written")
    static let diaryContentTextFieldPlaceholder: String = String(localized: "Your diary entry", defaultValue: "Your diary entry", comment: "This text is used as a TextField placeholder where the diary content should be written")
    static let diaryDateDatepickerDescription: String = String(localized: "Diary entry date", defaultValue: "Diary entry date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
    static let navigationBarTitle: String = String(localized: "Diary Entry", defaultValue: "Diary Entry", comment: "This is the navigation bar title in EditExistingDiaryEntryView")
}

struct EditExistingDiaryEntryView: View {
    @Environment(\.modelContext) private var context
    
    @State var diaryEntry: DiaryEntry
    
    init(diaryEntry: DiaryEntry) {
        self.diaryEntry = diaryEntry
    }
    
    var allTextFieldsFilled: Bool { !diaryEntry.heading.isEmpty && !diaryEntry.content.isEmpty }
    
    var body: some View {
        NavigationStack {
            EditEntryView(diaryEntry: $diaryEntry, mode: .view)
                .padding()
                .navigationTitle("Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Spacer()
                        Menu {
                            ShareLink("Share plain text", item: shareEntryText)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Spacer()
                        NavigationLink(destination: EntryAnalyticsView(diaryEntry: diaryEntry), label: {
                            Image(systemName: "chart.bar.fill")
                        })
                        Spacer()
                    }
                }
            Spacer()
        }
    }
    
    var shareEntryText: String {
        """
'\(diaryEntry.heading)' (\(diaryEntry.formattedDate))
\(diaryEntry.content)
"""
    }
}

#Preview {
    @State var diaryEntry: DiaryEntry = DiaryEntry(heading: "heading", content: "Sample content")
    
    return EditExistingDiaryEntryView(diaryEntry: diaryEntry)
}
