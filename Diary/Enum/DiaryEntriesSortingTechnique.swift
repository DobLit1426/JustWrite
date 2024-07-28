//
//  DiaryEntriesSortingTechnique.swift
//  Diary
//
//  Created by Dobromir Litvinov on 29.10.2023.
//

import Foundation

/// Describes the way the diary entries are sorted
/// - Important: The localized property is the localized textual representation of the sorting technique.
enum DiaryEntriesSortingTechnique: CaseIterable {
    
    /// Most recent diary entries at the beginning
    case newestAtTop
    
    /// Oldest diary entries at the beginning
    case oldestAtTop
    
    /// Diary entries with higher mood at the beginning
    case higherMoodAtTop
    
    /// Diary entries with higher mood at the beginning
    case lowerMoodAtTop
    
    /// Localized represantation of the sorting technique
    var localized: String {
        switch self {
        case .newestAtTop:
            return String(localized: "'Newest in the beginning' sorting technique", defaultValue: "Newest in the beginning", comment: "Textual representation of the DiaryEntriesSortingTechnique 'Newest in the beginning' sorting technique")
        case .oldestAtTop:
            return String(localized: "'Oldest in the beginning' sorting technique", defaultValue: "Oldest in the beginning", comment: "Textual representation of the DiaryEntriesSortingTechnique 'Oldest in the beginning' sorting technique")
        case .higherMoodAtTop:
            return String(localized: "'Higher mood in the beginning' sorting technique", defaultValue: "Higher mood in the beginning", comment: "Textual representation of the DiaryEntriesSortingTechnique 'Higher mood in the beginning' sorting technique")
        case .lowerMoodAtTop:
            return String(localized: "'Lower mood in the beginning' sorting technique", defaultValue: "Lower mood in the beginning", comment: "Textual representation of the DiaryEntriesSortingTechnique 'Lower mood in the beginning' sorting technique")
        }
    }
}
