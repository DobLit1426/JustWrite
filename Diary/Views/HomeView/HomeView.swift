//
//  HomeView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import SwiftData

fileprivate class LocalizedStrings {
    static let navigationBarTitle: String = String(localized: "My entries", defaultValue: "My entries", comment: "This is navigation bar title in HomeView")
    static let noEntriesText: String = String(localized: "There are currently no entries", defaultValue: "There are currently no entries", comment: "This text will be shown in HomeView when there are no diary entries")
}

enum DiaryEntriesSortingTechnique {
    case newestAtTop
    case oldestAtTop
}

struct HomeView: View {
    //MARK: - SwiftData properties
    @Environment(\.modelContext) private var swiftDataContext
    @Query(animation: .easeInOut) var entries: [DiaryEntry]
    
    //MARK: - ViewModel
    var homeViewModel: HomeViewModel
    
    //MARK: - @State variables
    @State var showAddNewEntryPopover: Bool = false
    @State var sortingTechnique: DiaryEntriesSortingTechnique = .newestAtTop
    @State var searchPromt: String = ""
    @State var searchActive: Bool = false
    
    //MARK: - Computed properties
    private var showEntriesList: Bool { !entries.isEmpty && searchPromt.isEmpty }
    private var showSearchResults: Bool { !searchPromt.isEmpty && searchActive }
    
    //MARK: - Init
    init() {
        homeViewModel = HomeViewModel()
    }
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if showEntriesList {
                    EntriesList(entries: entries, sortingTechnique: sortingTechnique) { entryIdToDelete in
                        deleteEntry(id: entryIdToDelete)
                    }
                    .animation(.easeInOut, value: sortingTechnique)
                } else if showSearchResults {
                    EntriesSearchResults(promt: searchPromt)
                    
                    Group {
                        let filteredEntries = entries.filter({ entry in
                            let promtTextInHeading: Bool = entry.heading.contains(searchPromt)
                            let promtTextInContent: Bool = entry.content.contains(searchPromt)
                            
                            let includeEntryInSearchResults: Bool = promtTextInHeading || promtTextInContent
                            return includeEntryInSearchResults
                        })
                        
                        let sortedEntries = filteredEntries.sorted { entryA, entryB in
                            if entryA.heading.contains(searchPromt) && entryB.heading.contains(searchPromt) {
                                return entryA.content.contains(searchPromt)
                            } else {
                                return entryA.heading.contains(searchPromt) && !entryB.heading.contains(searchPromt)
                            }
                        }
                        
                        if sortedEntries.isEmpty {
                            Text("No search results for \(searchPromt)")
                        } else {
                            List(sortedEntries) { entry in
                                NavigationLink {
                                    EditExistingDiaryEntryView(diaryEntry: entry)
                                } label: {
                                    EntriesListRow(entry: entry)
                                }
                            }
                        }
                    }
                    .animation(.easeInOut, value: searchPromt)
                } else {
                    Text(LocalizedStrings.noEntriesText)
                }
            }
#if os(macOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            .navigationTitle(LocalizedStrings.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddNewEntryPopover = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Picker(selection: $sortingTechnique) {
                        Text("Newest at top").tag(DiaryEntriesSortingTechnique.newestAtTop)
                        Text("Oldest at top").tag(DiaryEntriesSortingTechnique.oldestAtTop)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .popover(isPresented: $showAddNewEntryPopover) {
                NewEntryPopover { entryToSave in
                    swiftDataContext.insert(entryToSave)
                }
            }
            .background {
                List {
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: searchActive)
        }
        .searchable(text: $searchPromt, isPresented: $searchActive)
    }
    
    // MARK: - Private functions
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
