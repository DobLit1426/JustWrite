//
//  DebugDummyValues.swift
//  Diary
//
//  Created by Dobromir Litvinov on 03.08.24.
//

import Foundation

class DebugDummyValues {
    public enum PredefinedDiaryEntryMood {
        case positive
        case neutral
        case negative
        case none
    }
    
    static func diaryEntry(entryHeading: String = "This is a custom entry", customContentText: String? = nil, includeNormalText: Bool = true, includeMarkdownText: Bool = false, includeImages: Bool = true, includeDivider: Bool = true, predefinedMood: PredefinedDiaryEntryMood = .none, entryDate: Date = Date(timeIntervalSince1970: 1722690847), entryId: UUID = UUID()) -> DiaryEntry {
        
        var entryContent: [ContentBlockWrapper] = []
        
        if includeNormalText {
            entryContent.append(ContentBlockWrapper.textBlock(TextContentBlock(textSize: .h1, content: "This is some h1 text")))
        }
        
        if includeMarkdownText {
            entryContent.append(ContentBlockWrapper.textBlock(TextContentBlock(textSize: .h1, content: """
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
            """)))
        }
        
        if includeImages {
            // MARK: - TODO
        }
        
        if includeDivider {
            entryContent.append(ContentBlockWrapper.dividerBlock(DividerContentBlock(content: .thick)))
            entryContent.append(ContentBlockWrapper.dividerBlock(DividerContentBlock(content: .thin)))
        }
        
        let entryMood: Double?
        
        switch predefinedMood {
        case .positive:
            entryMood = 0.5
        case .neutral:
            entryMood = 0
        case .negative:
            entryMood = -0.5
        case .none:
            entryMood = nil
        }
        
        return DiaryEntry(
            heading: entryHeading,
            content: entryContent,
            mood: entryMood,
            date: entryDate,
            id: entryId
        )
    }
}
