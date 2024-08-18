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
                    analyticsForm
                } else {
                    Text("To see analytics write a few diary entries").padding()
                }
                
            }
            .navigationTitle("Analytics")
        }
        .onAppear {
            viewModel.update(with: entries)
        }
    }
    
    // MARK: - View variables
    @ViewBuilder private var analyticsForm: some View {
        Form {
            Section("Total") {
                AnalyticPropertyView(propertyName: "Entries", value: viewModel.totalNumberOfEntries)
                AnalyticPropertyView(propertyName: "Sentences", value: viewModel.totalNumberOfSentences)
                AnalyticPropertyView(propertyName: "Words", value: viewModel.totalNumberOfWords)
            }
            
            Section("Average") {
                AnalyticPropertyView(propertyName: "Sentences per entry", value: viewModel.averageNumberOfSentences)
                AnalyticPropertyView(propertyName: "Words in sentences", value: viewModel.averageNumberOfWordsPerSentence)
                AnalyticPropertyView(propertyName: "Days between diary entries", value: viewModel.averageNumberOfDaysBetweenDiaryEntries)
            }
            
            Section("Graphs") {
                MoodOverTimeGraph(dateToAverageMoodOfDate: viewModel.dateToAverageMoodOfDate)
                    .padding()
            }
        }
    }
}


#Preview {
    EntriesAnalyticsView()
        .modelContainer(for: DiaryEntry.self)
}
