//
//  EditEntryView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.10.2023.
//

import SwiftUI
import os

fileprivate struct LocalizedStrings {
    static let diaryDateDatepickerDescription: String = String(localized: "New Diary Entry - datePicker placeholder", defaultValue: "Date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
    
}

/// Used to edit entry using Binding.
/// - Important: This View provides interface to edit the provided diary entry, however it is **not** specified, where this interface can be used. This means, it can be used as well in a View to create new entry as in View to edit existing diary entries.
struct EditEntryView: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "EditEntryView")
    
    // MARK: - @Binding variables
    /// The diary entry to edit
    @Binding var diaryEntry: DiaryEntry
    
    // MARK: - @State variables
    /// S&D in which mode is the view
    @State var mode: DiaryEntryViewingMode
    
    // MARK: - @FocusState variables
    /// S&D whether the content text field is focused
    @FocusState var contentTextFieldFocused: Bool
    
    // MARK: - Computed variables
    /// Returns the earliest date that can be chosen as the date of the diaryEntry
    var datePickerStartingDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -100
        let date100YearsAgo = calendar.date(byAdding: dateComponents, to: currentDate)!
        return date100YearsAgo
    }

    // MARK: - Init
    /// Initialises View with DiaryEntry Binding and default mode, with whom the page will be shown for the first time
//    init(diaryEntry: DiaryEntry, defaultMode: DiaryEntryViewingMode) {
//        logger.info("Initialising EditEntryView...")
//        
//        self.mode = defaultMode
//        self.diaryEntry = diaryEntry
//        
//        logger.info("Successfully initialised EditEntryView")
//    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Picker(selection: $mode) {
                Text(DiaryEntryViewingMode.edit.rawValue).tag(DiaryEntryViewingMode.edit)
                Text(DiaryEntryViewingMode.view.rawValue).tag(DiaryEntryViewingMode.view)
            } label: {
                Text("Mode")
            }
            .pickerStyle(.segmented)
            
            VStack {
                if mode == .view {
                    EntryViewMode(diaryEntry: diaryEntry)
                } else {
                    DatePicker(LocalizedStrings.diaryDateDatepickerDescription, selection: $diaryEntry.date, in: datePickerStartingDate...Date.now)
                    
                    Divider()
                    
                    TextField("Heading", text: $diaryEntry.heading, axis: .vertical)
                        .lineLimit(nil)
                        .font(.largeTitle)
                        .onSubmit {
                            contentTextFieldFocused = true
                        }
                    
                    TextField("Content of your diary entry", text: $diaryEntry.content, axis: .vertical)
                        .lineLimit(nil)
                        .font(.body)
                        .focused($contentTextFieldFocused)
                        
                }
            }
        }
        .animation(.easeInOut, value: mode)
    }
}

#Preview {
    @State var entry: DiaryEntry = DiaryEntry(heading: "Role of the AI in our modern world", content: """
Well, as **you** see, ...

# Title 1
## Title 2
### Title 3
**Some bold text**
*Some cursive text*
***Bold and cursive text***
~Strikethrough text~
~~Strikethrough text 2~~
`Monospaced text`
""")


    return EditEntryView(diaryEntry: $entry, mode: .edit)
}
