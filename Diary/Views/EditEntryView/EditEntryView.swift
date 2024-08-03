//
//  EditEntryView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.10.2023.
//

import SwiftUI

fileprivate struct LocalizedStrings {
    static let diaryDateDatepickerDescription: String = String(localized: "New Diary Entry - datePicker placeholder", defaultValue: "Date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
    
    // TextField placeholders
    static let headingTextFieldPlaceholder: String = String(localized: "TextField diary entry heading placeholder", defaultValue: "Heading", comment: "This text is used as the placeholder for the TextField for the diary entry heading")
    static let contentTextFieldPlaceholder: String = String(localized: "TextField diary entry content placeholder", defaultValue: "Content of your diary entry", comment: "This text is used as the placeholder for the TextField for the diary entry content")
    
    // Mode picker
    static let modePickerLabel: String = String(localized: "Edit-View Mode Picker Label", defaultValue: "Mode", comment: "Used as the label for the Edit-View Mode Picker")
    static let modePickerEdit: String = String(localized: "Edit-View Mode Picker Edit option", defaultValue: "Edit", comment: "Used as the edit option text for the Edit-View Mode Picker")
    static let modePickerView: String = String(localized: "Edit-View Mode Picker View option", defaultValue: "View", comment: "Used as the view option text for the Edit-View Mode Picker")
}

/// Used to edit entry using Binding.
/// - Important: This View provides interface to edit the provided diary entry, however it is **not** specified, where this interface can be used. This means, it can be used as well in a View to create new entry as in View to edit existing diary entries.
struct EditEntryView: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "EditEntryView")
    
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
    
    // MARK: - Body
    var body: some View {
        VStack {
            Picker(selection: $mode) {
                Text(LocalizedStrings.modePickerEdit).tag(DiaryEntryViewingMode.edit)
                Text(LocalizedStrings.modePickerView).tag(DiaryEntryViewingMode.view)
            } label: {
                Text(LocalizedStrings.modePickerLabel)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            
            VStack {
                if mode == .view {
                    EntryViewMode(diaryEntry: diaryEntry)
                } else {
                    DatePicker(LocalizedStrings.diaryDateDatepickerDescription, selection: $diaryEntry.date, in: datePickerStartingDate...Date.now)
                    
                    Divider()
                    
                    TextField(LocalizedStrings.headingTextFieldPlaceholder, text: $diaryEntry.heading, axis: .vertical)
                        .lineLimit(nil)
                        .font(.largeTitle)
                        .onSubmit {
                            contentTextFieldFocused = true
                        }
                    
//                    TextField(LocalizedStrings.contentTextFieldPlaceholder, text: $diaryEntry.content, axis: .vertical)
//                        .lineLimit(nil)
//                        .font(.body)
//                        .focused($contentTextFieldFocused)
                        
                }
            }
        }
        .animation(.easeInOut, value: mode)
    }
}

#Preview {
    @State var entry: DiaryEntry = DebugDummyValues.diaryEntry(entryHeading: "Role of the AI in our modern world", includeMarkdownText: true)

    return EditEntryView(diaryEntry: $entry, mode: .edit)
}
