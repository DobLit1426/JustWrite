//
//  DeleteUserProfileAfterBeingInactiveFor.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.09.2023.
//

import Foundation

/// Enum describing after which time should all information the user created be deleted from the app if the app was inactive for this period of time. The rawValue is the localized textual representation of the time period.
enum DeleteUserProfileAfterBeingInactiveFor: Codable, CaseIterable, Hashable {
    case turnedOff
    case week
    case month
    case threeMonths
    case sixMonths
    case year
    
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
