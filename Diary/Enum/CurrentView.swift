//
//  CurrentView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.09.2023.
//

import Foundation

/// The enum is used on to specify the current view. The rawValue is used for debug purposes.
enum CurrentView: String {
    case appSetup = "appSetup"
    case diary = "diary"
    case none = "none"
}
