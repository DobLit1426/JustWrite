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
    @Query var encryptedDiaryEntries: [EncryptedDiaryEntry]
    
    //MARK: - ViewModel
    var homeViewModel: HomeViewModel {
        HomeViewModel(encryptedDiaryEntries: encryptedDiaryEntries, swiftDataContext: swiftDataContext)
    }
    
    //MARK: - body
    var body: some View {
        NavigationStack {
            VStack {
                if encryptedDiaryEntries.isEmpty {
                    Text(HomeViewLocalizedStrings.noEntriesText)
                } else {
                    entriesList
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
            ForEach(homeViewModel.decryptedDiaryEntries) { entry in
                NavigationLink(destination: EditExistingDiaryEntryView(diaryEntry: homeViewModel.dictionaryWithEntryBindings[entry.id]!)) {
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
                    ids.append(homeViewModel.decryptedDiaryEntries[index].id)
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
        let predicate = #Predicate<EncryptedDiaryEntry> { $0.id == id }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        if let entriesToDelete = try? swiftDataContext.fetch(fetchDescriptor), let entryToDelete = entriesToDelete.first {
            swiftDataContext.delete(entryToDelete)
        }
    }
}

#Preview {
    HomeView()
}
