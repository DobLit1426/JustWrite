//
//  InitialView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.10.2023.
//

import Foundation

/// The enum is used on to specify the initial view when the user opens the app. The rawValue is used for debug purposes.
enum InitialView: String {
    case appSetup = "appSetup"
    case diary = "diary"
    case authentication = "authentication"
    case none = "none"
}
