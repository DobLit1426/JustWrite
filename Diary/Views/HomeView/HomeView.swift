//
//  HomeView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import SwiftData
import NaturalLanguage
import CoreML

fileprivate class LocalizedStrings {
    static let navigationBarTitle: String = String(localized: "My entries", defaultValue: "My entries", comment: "This is navigation bar title in HomeView")
    static let noEntriesText: String = String(localized: "There are currently no entries", defaultValue: "There are currently no entries", comment: "This text will be shown in HomeView when there are no diary entries")
}

struct HomeView: View {
    // MARK: - Logger
    private let logger: AppLogger = AppLogger(category: "HomeView")
    
    // MARK: - SwiftData properties
    @Environment(\.modelContext) private var swiftDataContext
    @Query(animation: .easeInOut) var entries: [DiaryEntry]
    
    // MARK: - ViewModel
    var homeViewModel: HomeViewModel
    
    // MARK: - @State variables
    @State var showAddNewEntryPopover: Bool = false
    @State var sortingTechnique: DiaryEntriesSortingTechnique = .newestAtTop
    @State var searchPromt: String = ""
    @State var searchActive: Bool = false
    
    // MARK: @State variables - NLModel-s
    @State private var sentimentPredictor: NLModel? = nil
    @State private var emotionalityRecognizer: NLModel? = nil
    
    // MARK: - Computed properties
    private var showEntriesList: Bool { !entries.isEmpty && searchPromt.isEmpty }
    private var showSearchResults: Bool { !searchPromt.isEmpty && searchActive }
    
    // MARK: - Init
    init() {
        homeViewModel = HomeViewModel()
    }
    
    // MARK: - Body
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
                        .animation(.easeInOut, value: searchPromt)
                } else {
                    Text(LocalizedStrings.noEntriesText)
                }
                
                if !entries.isEmpty {
                    EmptyView()
                        .searchable(text: $searchPromt, isPresented: $searchActive)
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
                
                if !entries.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        SortingMenu(sortingTechnique: $sortingTechnique)
                    }
                }
            }
            .sheet(isPresented: $showAddNewEntryPopover) {
                NewEntryPopover { entryToSave in
                    #if DEBUG
                    let someDummyEntry: DiaryEntry = DebugDummyValues.diaryEntry(entryHeading: entryToSave.heading, includeNormalText: true, includeMarkdownText: true)
                    swiftDataContext.insert(someDummyEntry)
                    #endif
                
                    swiftDataContext.insert(entryToSave)
                }
            }
            .animation(.easeInOut, value: searchActive)
            .onAppear {
                setupModels()
                predictMoodForEntries()
            }
            .onChange(of: entries) {
                predictMoodForEntries()
            }
        }
    }
    
    // MARK: - Private functions
    private func deleteEntry(id: UUID) {
        let predicate = #Predicate<DiaryEntry> { $0.id == id }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        if let entriesToDelete = try? swiftDataContext.fetch(fetchDescriptor), let entryToDelete = entriesToDelete.first {
            swiftDataContext.delete(entryToDelete)
        }
    }
    
    
    // MARK: - Sentiment recognition functions
    private func performSentimentAnalysis(for entry: DiaryEntry) -> Double? {
        return EntriesAnalyzer.sentimentAnalysis(for: entry.allEntryTextInSingleString, sentimentPredictor: sentimentPredictor, emotionalityRecognizer: emotionalityRecognizer)
    }
    
    private func setupModels() {
        guard let models = EntriesAnalyzer.setupModels() else {
            logger.critical("No NL models were created")
            return
        }
        
        sentimentPredictor = models.0
        emotionalityRecognizer = models.1
    }
    
    private func predictMoodForEntries() {
        for entry in entries {
//            if entry.mood == nil {
                entry.mood = performSentimentAnalysis(for: entry)
//            }
        }
    }
}

#Preview {
    HomeView()
}
