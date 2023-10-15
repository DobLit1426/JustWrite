//
//  CurrentView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.09.2023.
//

import Foundation

/// Used on to specify the current view.
/// - Warning: The rawValue can be used ONLY for debug purposes.
enum CurrentView: String {
    /// Current view is app setup view
    case appSetup = "appSetup"
    
    /// Current view shows the diary
    case diary = "diary"
    
    /// There's no current view
    case none = "none"
}
