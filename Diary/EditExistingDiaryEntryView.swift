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
    
    @Binding var diaryEntry: DiaryEntry
    
    var datePickerStartingDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -100
        let date100YearsAgo = calendar.date(byAdding: dateComponents, to: currentDate)!
        return date100YearsAgo
    }
    
    
    var formattedDate: String {
        diaryEntry.formattedDate
    }
    
    var allTextFieldsFilled: Bool { !diaryEntry.heading.isEmpty && !diaryEntry.content.isEmpty }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Divider()
                ScrollView {
                    DatePicker(EditExistingDiaryEntryViewLocalizedStrings.diaryDateDatepickerDescription, selection: $diaryEntry.date, in: datePickerStartingDate...Date.now)
                    
                    Divider()
                    
                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField(EditExistingDiaryEntryViewLocalizedStrings.diaryHeadingTextFieldPlaceholder, text: $diaryEntry.heading, axis: .vertical)
                        .font(.title)
                        .bold()
                    
                    TextField(EditExistingDiaryEntryViewLocalizedStrings.diaryContentTextFieldPlaceholder, text: $diaryEntry.content, axis: .vertical)
                        .font(.body)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //                ShareLink("Share", item: "'\(diaryEntry.heading)' from \(diaryEntry.formattedDate)\n\(diaryEntry.content)\n")
                
                ToolbarItemGroup(placement: .navigation) {
                    Spacer()
                    VStack {
                        ShareLink(item: shareEntryText, label: {Label(
                            title: { Text("Share entry") },
                            icon: { Image(systemName: "square.and.arrow.up") }
                        )})
                    }
                    Spacer()
                    NavigationLink(destination: EntryAnalyticsView(diaryEntry: diaryEntry), label: {Image(systemName: "chart.bar.fill")})
                    Spacer()
                }
            }
        }
    }

    var shareEntryText: String {
        """
Diary entry from \(diaryEntry.formattedDate)
-----------
'\(diaryEntry.heading)'
\(diaryEntry.content)
-----------
"""
    }
}

#Preview {
    @State var diaryEntry: DiaryEntry = DiaryEntry(heading: "heading", content: "Sample content")
    let dummyEntryBinding: Binding<DiaryEntry> = Binding {
        return diaryEntry
    } set: { newValue in
        diaryEntry = diaryEntry
    }
    
    return EditExistingDiaryEntryView(diaryEntry: dummyEntryBinding)
}
