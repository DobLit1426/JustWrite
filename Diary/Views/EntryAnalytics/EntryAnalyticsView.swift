//
//  EntryAnalytics.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.10.2023.
//

import SwiftUI
import Charts
import NaturalLanguage
import CoreML

struct ChartSector: Identifiable {
    let id: UUID = UUID()
    let part: Double
    let name: String
}


struct EntryAnalyticsView: View {
    private let logger: AppLogger = AppLogger(category: "EntryAnalyticsView")
    
    let diaryEntry: DiaryEntry
    
    @State var chartSectors = [ChartSector]()
    
    
    @StateObject private var viewModel: EntryAnalyticsViewModel = EntryAnalyticsViewModel()
    @State private var emotionalityRecognizer: NLModel?
    @State private var sentimentPredictor: NLModel?
    @State private var selectedSection: Int = 0
    
    var sentencesToMood: [SentenceMood] { viewModel.sentencesToMood }
    var numberOfWords: Int { viewModel.numberOfWords }
    var numberOfSentences: Int { viewModel.numberOfSentences }
    var medianMood: Double { viewModel.averageMood }
    var averageNumberOfWordsInSentence: Double { viewModel.averageNumberOfWordsInSentence }
    
    var numberOfPositiveSentences: Int { viewModel.numberOfPositiveSentences }
    var numberOfNegativeSentences: Int { viewModel.numberOfNegativeSentences }
    var numberOfNeutralSentences: Int { viewModel.numberOfNeutralSentences }
    
    
    //    var body: some View {
    //        NavigationStack {
    //            VStack {
    //                TabView(selection: $selectedSection) {
    //                    ForEach(sections.startIndex..<sections.endIndex, id: \.description) { index in
    //                        sections[index].tag(index)
    //                    }
    //                }
    //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    //                .gesture(DragGesture().onEnded({ value in
    //                    if value.translation.width < 0 {
    //                        selectedSection = min(selectedSection + 1, 2)
    //                    } else {
    //                        selectedSection = max(selectedSection - 1, 0)
    //                    }
    //                }))
    //
    //                SectionIndicator(currentIndex: selectedSection, numberOfSections: sections.count)
    //            }
    //            .navigationTitle("Analytics")
    //        }
    //        .onAppear {
    //            setupModels()
    //            viewModel.update(entry: diaryEntry, sentimentPredictor: sentimentPredictor!, emotionalityRecognizer: emotionalityRecognizer!)
    //            chartSectors = [ChartSector(part: Double(numberOfPositiveSentences)/Double(numberOfSentences), name: "Positive sentences"), ChartSector(part: Double(numberOfNegativeSentences)/Double(numberOfSentences), name: "Negative sentences"), ChartSector(part: Double(numberOfNeutralSentences)/Double(numberOfSentences), name: "Neutral sentences")]
    //        }
    //    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    EntryAnalyticsQuestionSymbol()
                    
                    Spacer()
                    Spacer()
                    
                    NavigationLink {
                        EntryAnalyticsMoodDistributionChart(sentencesToMood: sentencesToMood)
                    } label: {
                        EntryAnalyticsChartSymbol()
                    }
                    
                    Spacer()
                }
                
                MoodSpeedometer(value: diaryEntry.formattedMood ?? 0)
                    .padding()
                
                HStack {
                    Spacer()
                    
                    EntryAnalyticsDataSymbol()
                    
                    Spacer()
                    Spacer()
                    
                    NavigationLink {
                        EntryAnalyticsPieChart(numberOfPositiveSentences: numberOfPositiveSentences, numberOfNegativeSentences: numberOfNegativeSentences, numberOfNeutralSentences: numberOfNeutralSentences)
                    } label: {
                        EntryAnalyticsPieChartSymbol()
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupModels()
            viewModel.update(entry: diaryEntry, sentimentPredictor: sentimentPredictor!, emotionalityRecognizer: emotionalityRecognizer!)
        }
    }
    
    private var section4: some View {
        VStack {
            Text("Stats")
                .font(.title)
            Spacer()
            Text("Number of positive sentences: \(numberOfPositiveSentences)")
            Text("Number of neutral sentences: \(numberOfNeutralSentences)")
            Text("Number of negative sentences: \(numberOfNegativeSentences)")
            
            Text("Number of sentences: \(numberOfSentences)")
            Text("Number of words: \(numberOfWords)")
            Text("Average number of words per sentence: \(averageNumberOfWordsInSentence)")
            Text("Average mood: \(medianMood)")
            
            Spacer()
        }
        .padding()
    }
    
    private var section3: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                
                VStack {
                    Text("Bar Chart")
                        .font(.title)
                    Chart(chartSectors) { sector in
                        BarMark(x: .value(sector.name, sector.part))
                            .foregroundStyle(by: .value("Name", sector.name))
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height < 100 ? 400 : geometry.size.height * 0.9)
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    init(diaryEntry: DiaryEntry) {
        self.diaryEntry = diaryEntry
    }
    
    private func setupModels() {
        guard let models = EntriesAnalyzer.setupModels() else {
            logger.critical("No NL models were created")
            return
        }
        
        sentimentPredictor = models.0
        emotionalityRecognizer = models.1
    }
}

struct SectionIndicator: View {
    let currentIndex: Int
    let numberOfSections: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfSections, id: \.self) { index in
                Rectangle()
                    .frame(width: 20, height: 4)
                    .foregroundColor(index == currentIndex ? .blue : .gray)
                    .cornerRadius(2)
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    let entry: DiaryEntry = DiaryEntry(heading: "My complex day", content: """
The day began with a cacophony of sound as the alarm clock rudely disrupted my peaceful slumber. After a few groggy moments, I dragged myself out of bed and embarked on my morning routine. As I stood in front of the mirror, I couldn't help but reflect on the complexities of life.

Breakfast was a concoction of flavors, as I experimented with a new recipe that I had stumbled upon in a cookbook. The intricate blend of spices and the precision required in the preparation process left me feeling both accomplished and eager to tackle the challenges that lay ahead.

The complexity of the day intensified as I delved into my work. I am a computer programmer, and today's task involved debugging a convoluted piece of code that had stumped my colleagues for days. The code was riddled with nested loops and conditional statements that seemed to interact in unpredictable ways.

With unwavering determination, I meticulously traced each variable's value, inserted detailed comments to explain my thought process, and finally, after hours of careful analysis and experimentation, I cracked the code's enigma. The exhilaration of solving this complex problem was a testament to the beauty of problem-solving in the world of programming.

The complexity of the day intensified as I delved into my work. I am a computer programmer, and today's task involved debugging a convoluted piece of code that had stumped my colleagues for days. The code was riddled with nested loops and conditional statements that seemed to interact in unpredictable ways.

With unwavering determination, I meticulously traced each variable's value, inserted detailed comments to explain my thought process, and finally, after hours of careful analysis and experimentation, I cracked the code's enigma. The exhilaration of solving this complex problem was a testament to the beauty of problem-solving in the world of programming.

The afternoon was filled with a series of meetings that demanded attention to detail and sharp analytical thinking. We were tackling complex business problems, considering various strategies, and evaluating potential risks. The discussions were intellectually stimulating but mentally taxing, requiring me to navigate a labyrinth of ideas and proposals.

As the workday drew to a close, I attended a yoga class to unwind and de-stress. The intricacies of mastering yoga poses and the focus required for proper breathing provided a welcome respite from the day's complexities. It was a moment of serenity amidst the chaos.

The day ended with a captivating novel that transported me to a world of complex characters and intricate plot twists. I marveled at the author's ability to weave such an intricate narrative, and it reminded me of the power of storytelling to illuminate the complexities of the human experience.

As I lay down to rest, my mind buzzed with the day's events. This diary entry, dear diary, is but a glimpse into the intricate tapestry of my life, filled with challenges, triumphs, and the ever-present beauty of complexity.
""")
    return EntryAnalyticsView(diaryEntry: entry).modelContainer(for: DiaryEntry.self)
}
