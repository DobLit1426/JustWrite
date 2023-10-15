//
//  DeleteUserProfileAfterBeingInactiveFor.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.09.2023.
//

import Foundation

/// Describes after which time should all information the user created be deleted from the app if the app was inactive for this period of time. 
/// - Important: The rawValue is the localized textual representation of the time period. The rawValue is NOT native Swift rawValue.
enum DeleteUserProfileAfterBeingInactiveFor: Codable, CaseIterable, Hashable {
    /// The setting is turned off
    case turnedOff
    
    /// Delete after being inactive for a week
    case week
    
    /// Delete after being inactive for a month
    case month
    
    /// Delete after being inactive for three months
    case threeMonths
    
    /// Delete after being inactive for six months
    case sixMonths
    
    /// Delete after being inactive for a year
    case year
    
    /// Localized String based on the enum's value.
    /// - Important: This is NOT native Swift rawValue.
    var rawValue: String {
        let comment: String = "This string is used as the rawValue for an instance of DeleteUserProfileAfterBeingInactiveFor"
        
        var rawValue: String = ""
        switch self {
        case .turnedOff: rawValue = "Turned off"
        case .week: rawValue = "After 1 week"
        case .month: rawValue = "After 1 month"
        case .threeMonths: rawValue = "After 3 months"
        case .sixMonths: rawValue = "After 6 months"
        case .year: rawValue = "After 1 year"
        }
        
        return NSLocalizedString(rawValue, comment: comment)
    }
}
