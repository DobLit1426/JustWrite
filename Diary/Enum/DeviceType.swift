//
//  DeviceType.swift
//  Diary
//
//  Created by Dobromir Litvinov on 29.10.2023.
//

import Foundation

/// Describes all possible types of devices the app can be run on
enum DeviceType {
    /// iPad
    case iPad
    
    /// iPhone
    case iPhone
    
    /// VisionPro
    case vision
    
    /// Device that runs on MacOS
    case mac
    
    /// Apple TV
    case tv
    
    /// Device couldn't be identified
    case unknownDevice
}
