//
//  NavigationManager.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI

struct NavigationManager: View {
    //MARK: - @State variables
    @State var currentTab: CurrentTab = .homeView
    
    //MARK: - Init
    /// Initialises NavigationManager. The currentTab is set to it's default value
    init() { }
    
    //MARK: - Localized text
    let homeviewTabItemLabelText: String = String(localized: "My Entries", defaultValue: "My Entries", comment: "This is tab item label text for HomeView")
    let addNewEntryViewTabItemLabelText: String = String(localized: "New Entry", defaultValue: "New Entry", comment: "This is tab item label text for AddNewEntryView")
    let settingsViewTabItemLabelText: String = String(localized: "Settings Tab Name", defaultValue: "Settings", comment: "This is tab item label text for SettingsView")
    let analyticsViewTabItemLabelText: String = String(localized: "Analytics Tab Name", defaultValue: "Analytics", comment: "This is tab item label text for EntriesAnalyticsView")
    
    //MARK: - body
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView()
                .tabItem {
                    Label(homeviewTabItemLabelText, systemImage: "list.dash")
                }
                .tag(CurrentTab.homeView)
            
            AddNewEntryView(currentTab: $currentTab)
                .tabItem {
                    Label(addNewEntryViewTabItemLabelText, systemImage: "plus")
                }
                .tag(CurrentTab.addNewEntryView)
            
            EntriesAnalyticsView()
                .tabItem {
                    Label(analyticsViewTabItemLabelText, systemImage: "chart.bar.xaxis")
                }
                .tag(CurrentTab.analytics)
            
            SettingsView()
                .tabItem {
                    Label(settingsViewTabItemLabelText, systemImage: "gear")
                }
                .tag(CurrentTab.settings)
        }
    }
}

#Preview {
    NavigationManager()
}
