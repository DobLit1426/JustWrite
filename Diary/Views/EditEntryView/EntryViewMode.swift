//
//  DiaryEntryViewMode.swift
//  Diary
//
//  Created by Dobromir Litvinov on 28.10.2023.
//

import SwiftUI
import os

/// Shows the diary entry in View Mode
struct EntryViewMode: View {
    // MARK: - Logger
    /// Logger instance
    let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "EntryViewMode")
    
    // MARK: - Constants
    /// The diary entry to view
    let diaryEntry: DiaryEntry
    
    // MARK: - Computed properties
    /// Shows whether the entry content is empty
    var entryContentIsEmpty: Bool { !diaryEntry.content.contains(where: { !$0.isWhitespace }) }
    
    /// Shows whether the entry heading is empty
    var entryHeadingIsEmpty: Bool { !diaryEntry.heading.contains(where: { !$0.isWhitespace }) }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            Text(diaryEntry.formattedDate)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            if entryHeadingIsEmpty {
                TextField("Heading", text: .constant(""))
                    .font(.largeTitle)
                    .disabled(true)
                    .lineLimit(nil)
            } else {
                Text(diaryEntry.heading)
                .font(.largeTitle)
                .foregroundStyle(entryHeadingIsEmpty ? .gray : .primary)
            }
                
            if entryContentIsEmpty {
                TextField("Content of your diary entry", text: .constant(""))
                    .font(.body)
                    .disabled(true)
                    .lineLimit(nil)
            } else {
                ForEach(parseMarkdownText(diaryEntry.content), id: \.self) { line in
                    MarkdownText(text: line)
                }
            }
        }
    }
    
    // MARK: - Private functions
    /// Divides the provided text into components to apply Markdown on
    private func parseMarkdownText(_ text: String) -> [String] {
        return text.components(separatedBy: "\n")
    }
}

#Preview {
    EntryViewMode(diaryEntry: DiaryEntry(heading: "Test", content: "test"))
}
