//
//  EntryAnalyticsViewPrototype.swift
//  Diary
//
//  Created by Dobromir Litvinov on 17.11.2023.
//

import SwiftUI

struct EntryAnalyticsViewPrototype: View {
    let mood: Int = 4
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                EntryAnalyticsQuestionSymbol()
                Spacer()
                Spacer()
                EntryAnalyticsChartSymbol()
                Spacer()
            }
            
            MoodSpeedometer(value: 3)
                .padding()
            
            HStack {
                Spacer()
                EntryAnalyticsDataSymbol()
                Spacer()
                Spacer()
                EntryAnalyticsPieChartSymbol()
                Spacer()
            }
            Spacer()
        }
    }
}

struct EntryAnalyticsQuestionSymbol: View {
    var body: some View {
        EntryAnalyticsNavigationLinkButtonView(systemImage: "questionmark")
    }
}

struct EntryAnalyticsPieChartSymbol: View {
    var body: some View {
        EntryAnalyticsNavigationLinkButtonView(systemImage: "chart.pie")
    }
}

struct EntryAnalyticsChartSymbol: View {
    var body: some View {
        EntryAnalyticsNavigationLinkButtonView(systemImage: "chart.xyaxis.line")
    }
}

struct EntryAnalyticsDataSymbol: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60)
                .foregroundStyle(.background)
            
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 60)

            VStack {
                Text("101001")
                Text("010101")
                Text("100101")
            }
            .font(.system(size: 10))
            .foregroundStyle(.tint)
        }
    }
}

struct EntryAnalyticsNavigationLinkButtonView: View {
    let systemImage: String
    
    init(systemImage: String) {
        self.systemImage = systemImage
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60)
                .foregroundStyle(.background)
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 60)
            
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundStyle(.tint)
        }
    }
}

#Preview {
    EntryAnalyticsViewPrototype()
}
