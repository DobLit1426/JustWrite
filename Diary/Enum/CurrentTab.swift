//
//  CurrentTab.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.10.2023.
//

import Foundation

/// Used to show which tab in TabView is currently chosen
enum CurrentTab: Hashable {
    /// The home view tab
    case homeView
    
    /// The settings tab
    case settings
    
    /// The analytics tab
    case analytics
}
