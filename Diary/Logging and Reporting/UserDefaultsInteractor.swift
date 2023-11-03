//
//  UserDefaultsInteractor.swift
//  Diary
//
//  Created by Dobromir Litvinov on 31.10.2023.
//

import Foundation

struct UserDefaultsInteractor {
    static func setSendAnonymousReportsValue(_ value: Bool) {
        UserDefaults.standard.setValue(value, forKey: AppLogger.userDefaultsSendAnonymousReportsKey)
    }
    
    /// If value exists, returns it, otherwise creates default value, saves it and returns it
    static func getSendAnonymousReportsValue() -> Bool {
        let key = AppLogger.userDefaultsSendAnonymousReportsKey
        let standard = UserDefaults.standard
        let userDefaultsValue = standard.object(forKey: key) as? Bool
        if userDefaultsValue == nil {
            // Value doesn't exist
            let value = AppLogger.userDefaultsSendAnonymousReportsDefaultValue
            standard.setValue(value, forKey: key)
            return value
        } else {
            // Value exists
            return userDefaultsValue!
        }
    }
}
