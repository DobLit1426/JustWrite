//
//  HomeView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import SwiftData

fileprivate class HomeViewLocalizedStrings {
    static let navigationBarTitle: String = String(localized: "My entries", defaultValue: "My entries", comment: "This is navigation bar title in HomeView")
    static let noEntriesText: String = String(localized: "There are currently no entries", defaultValue: "There are currently no entries", comment: "This text will be shown in HomeView when there are no diary entries")
}

struct HomeView: View {
    //MARK: - SwiftData properties
    @Environment(\.modelContext) private var swiftDataContext
    @Query var entries: [DiaryEntry]
    
    //MARK: - ViewModel
    var homeViewModel: HomeViewModel
    
    //MARK: - Computed properties
    private var showEntriesList: Bool { !entries.isEmpty }
    
    //MARK: - Init
    init() {
        homeViewModel = HomeViewModel()
    }
    
    //MARK: - body
    var body: some View {
        NavigationStack {
            VStack {
                if showEntriesList {
                    entriesList
                } else {
                    Text(HomeViewLocalizedStrings.noEntriesText)
                }
            }
            #if os(macOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .navigationTitle(HomeViewLocalizedStrings.navigationBarTitle)
        }
    }
    
    var entriesList: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                NavigationLink {
                    EditExistingDiaryEntryView(diaryEntry: entry)
                } label: {
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
            deleteEntry(id: id)
        }
    }
    
    private func deleteEntry(id: UUID) {
        let predicate = #Predicate<DiaryEntry> { $0.id == id }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        if let entriesToDelete = try? swiftDataContext.fetch(fetchDescriptor), let entryToDelete = entriesToDelete.first {
            swiftDataContext.delete(entryToDelete)
        }
    }
}

#Preview {
    HomeView()
}
