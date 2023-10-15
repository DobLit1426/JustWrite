//
//  AuthenticationMethod.swift
//  Diary
//
//  Created by Dobromir Litvinov on 12.09.2023.
//

import Foundation

enum AuthenticationMethod: String, CaseIterable, Codable, Hashable  {
    case biometric = "Biometric"
    case password = "Password"
    case biometricAndPassword = "Biometric and password authentication method"
    case none = "I don't want to use any authentication method"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
