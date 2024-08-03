//
//  EditExistingDiaryEntryView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData
import NaturalLanguage
import CoreML

fileprivate class LocalizedStrings {
    static let diaryHeadingTextFieldPlaceholder: String = String(localized: "Heading of the diary entry", defaultValue: "Heading of the diary entry", comment: "This text is used as a TextField placeholder where the diary entry should be written")
    static let diaryContentTextFieldPlaceholder: String = String(localized: "Your diary entry", defaultValue: "Your diary entry", comment: "This text is used as a TextField placeholder where the diary content should be written")
    static let diaryDateDatepickerDescription: String = String(localized: "Diary entry date", defaultValue: "Diary entry date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
    static let navigationBarTitle: String = String(localized: "Diary Entry", defaultValue: "Diary Entry", comment: "This is the navigation bar title in EditExistingDiaryEntryView")
}

struct EditExistingDiaryEntryView: View {
    // MARK: - Logger
    private let logger: AppLogger = AppLogger(category: "EditExistingDiaryEntryView")
    
    // MARK: - @Environment variables
    @Environment(\.modelContext) private var context
    
    // MARK: - @State variables
    @State var diaryEntry: DiaryEntry
    @State private var numberOfWords: Int = 0
    
    @State private var sentimentPredictor: NLModel? = nil
    @State private var emotionalityRecognizer: NLModel? = nil
    
    // MARK: - Computed properties
    var allTextFieldsFilled: Bool { !diaryEntry.heading.isEmpty && !diaryEntry.content.isEmpty }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            EditEntryView(diaryEntry: $diaryEntry, mode: .view)
                .padding()
                .navigationTitle("Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        ShareDiaryEntryButton(diaryEntry: diaryEntry)

                        NavigationLink(destination: EntryAnalyticsView(diaryEntry: diaryEntry), label: {
                            if let formattedMood = diaryEntry.formattedMood {
                                Spacer()
                                MoodGauge(mood: formattedMood)
                                    .scaleEffect(CGSize(width: 0.6, height: 0.6))
                            } else {
                                Image(systemName: "chart.bar.fill")
                            }
                        })
                    }
                }
            Spacer()
        }
        .onChange(of: diaryEntry.content, { oldValue, newValue in
            predictMoodForTheEntry()
        })
        .onAppear {
            setupModels()
            predictMoodForTheEntry()
        }
    }
    
    // MARK: - Sentiment recognition functions
    private func setupModels() {
        guard let models = EntriesAnalyzer.setupModels() else {
            logger.critical("No NL models were created")
            return
        }
        
        sentimentPredictor = models.0
        emotionalityRecognizer = models.1
    }
    
    private func predictMoodForTheEntry() {
        diaryEntry.mood = EntriesAnalyzer.sentimentAnalysis(for: diaryEntry, sentimentPredictor: sentimentPredictor, emotionalityRecognizer: emotionalityRecognizer)
    }
}

#Preview {
    @State var diaryEntry: DiaryEntry = DebugDummyValues.diaryEntry()
    
    return EditExistingDiaryEntryView(diaryEntry: diaryEntry)
}
