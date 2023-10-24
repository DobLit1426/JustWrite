//
//  HomeViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 24.09.2023.
//

import Foundation
import CryptoKit
import os
import SwiftData
import SwiftUI

class HomeViewModel: ObservableObject {
    private var logger: Logger = Logger(subsystem: ".diaryApp", category: "HomeViewViewModel")
    
    init() {
        logger.info("Starting intialising HomeViewViewModel object")
        
        logger.info("Successfully intialised ViewModel object")
    }
}
