//
//  DeleteUserProfileAfterBeingInactiveFor.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.09.2023.
//

import Foundation

/// Describes after which time should all information the user created be deleted from the app if the app was inactive for this period of time. 
/// - Important: localized is the localized textual representation of the time period.
enum DeleteEntriesAfterBeingInactiveFor: Codable, CaseIterable, Hashable {
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
    
    /// Localized String based on the enum's value
    var localized: String {
        var defaultValue: String.LocalizationValue = ""
        switch self {
        case .turnedOff: 
            defaultValue = "Turned off"
        case .week:
            defaultValue = "After 1 week"
        case .month: 
            defaultValue = "After 1 month"
        case .threeMonths: 
            defaultValue = "After 3 months"
        case .sixMonths: 
            defaultValue = "After 6 months"
        case .year: 
            defaultValue = "After 1 year"
        }
        
        let comment: StaticString = "This string is used as the rawValue for an instance of DeleteEntriesAfterBeingInactiveFor"
        let localizedKey: StaticString = "'Delete entries after being inactive for' enum localized value"
        
        return String(localized: localizedKey, defaultValue: defaultValue, comment: comment)
    }
    
    
    /// Used to different values, e.g. in a Picker
    var id: Int {
        switch self {
        case .turnedOff:
            return 0
        case .week:
            return 1
        case .month:
            return 2
        case .threeMonths:
            return 3
        case .sixMonths:
            return 4
        case .year:
            return 5
        }
    }
}
