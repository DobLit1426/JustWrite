//
//  EntriesAnalytics.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.10.2023.
//

import SwiftUI
import SwiftData

struct EntriesAnalyticsView: View {
    @Query private var entries: [DiaryEntry]
    
    @StateObject private var viewModel: EntriesAnalyticsViewModel = EntriesAnalyticsViewModel()
    
    private var showAnalytics: Bool { !entries.isEmpty }
    
    var body: some View {
        NavigationStack {
            VStack {
                if showAnalytics {
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
                } else {
                    Text("To see analytics write a diary entry")
                        .padding()
                }
            }
            .navigationTitle("Analytics")
        }
        .onAppear {
            viewModel.update(with: entries)
        }
    }
}


#Preview {
    EntriesAnalyticsView()
        .modelContainer(for: DiaryEntry.self)
}
