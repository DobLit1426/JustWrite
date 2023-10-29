//
//  EntriesList.swift
//  Diary
//
//  Created by Dobromir Litvinov on 29.10.2023.
//

import SwiftUI
import os

struct EntriesList: View {
    private static let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "EntriesList")
    private let logger: Logger = EntriesList.logger
    
    let entries: [DiaryEntry]
    let onDelete: (_ entryID: UUID) -> Void
    let sortingTechnique: DiaryEntriesSortingTechnique
    
    init(entries: [DiaryEntry], sortingTechnique: DiaryEntriesSortingTechnique = .newestAtTop, onDelete: @escaping (_: UUID) -> Void) {
        self.entries = EntriesList.sortEntries(entriesToSort: entries, basedOn: sortingTechnique)
        self.onDelete = onDelete
        self.sortingTechnique = sortingTechnique
    }
    
    var body: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                NavigationLink {
                    EditExistingDiaryEntryView(diaryEntry: entry)
                } label: {
                    EntriesListRow(entry: entry)
                }
            }
            .onDelete(perform: { indexSet in
                var ids = [UUID]()
                for index in indexSet {
                    if let entry = entries.first(where: { $0.id == entries[index].id }) {
                        ids.append(entry.id)
                    }
                }
                deleteEntries(ids: ids)
            })
        }
    }
    
    private func deleteEntries(ids: [UUID]) {
        for id in ids {
            onDelete(id)
        }
    }
    
    private static func sortEntries(entriesToSort: [DiaryEntry], basedOn sortingTechnique: DiaryEntriesSortingTechnique) -> [DiaryEntry] {
        switch sortingTechnique {
        case .newestAtTop:
            return entriesToSort.sorted { entry1, entry2 in
                return entry1.date > entry2.date
            }
        case .oldestAtTop:
            return entriesToSort.sorted { entry1, entry2 in
                return entry1.date < entry2.date
            }
        default:
            logger.critical("The used sorting technique isn't in the switch, returning entries with newest at the top")
            return entriesToSort.sorted { entry1, entry2 in
                return entry1.date > entry2.date
            }
        }
        
    }
}

#Preview {
    EntriesList(entries: [DiaryEntry(heading: "Diary Entry 1", content: "Some content")]) {
        print("Deleting entry with id \($0)")
    }
}
