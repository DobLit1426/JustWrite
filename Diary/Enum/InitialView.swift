//
//  InitialView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.10.2023.
//

import Foundation

/// Used on to specify the initial view when the user opens the app.
/// - Warning: The rawValue can be used ONLY for debug purposes.
enum InitialView: String {
    /// The initial view is app setup view
    case appSetup = "appSetup"
    
    /// The intial view shows unlocked diary
    case diary = "diary"
    
    /// The initial view is authentication view
    case authentication = "authentication"
    
    /// The initial view isn't specified
    case none = "none"
}
