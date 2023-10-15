//
//  EntriesAnalytics.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.10.2023.
//

import SwiftUI
import SwiftData

struct EntriesAnalyticsView: View {
    @State var navigationPath: NavigationPath = NavigationPath()
    @Query private var encrypted_entries: [EncryptedDiaryEntry]
    
    @StateObject private var viewModel: EntriesAnalyticsViewModel = EntriesAnalyticsViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("Total") {
                    AnalyticProperty(propertyName: "Entries", value: viewModel.totalNumberOfEntries)
                    AnalyticProperty(propertyName: "Sentences", value: viewModel.totalNumberOfSentences)
                    AnalyticProperty(propertyName: "Words", value: viewModel.totalNumberOfWords)
                }
                
                Section("Average") {
                    AnalyticProperty(propertyName: "Sentences per entry", value: viewModel.averageNumberOfSentences)
                    AnalyticProperty(propertyName: "Words in sentences", value: viewModel.averageNumberOfWordsPerSentence)
                    AnalyticProperty(propertyName: "Days between diary entries", value: viewModel.averageNumberOfDaysBetweenDiaryEntries)
                }
            }
            .navigationTitle("Analytics")
        }
        .onAppear {
            viewModel.update(with: encrypted_entries)
        }
    }
}

#Preview {
    EntriesAnalyticsView()
        .modelContainer(for: EncryptedDiaryEntry.self)
}
