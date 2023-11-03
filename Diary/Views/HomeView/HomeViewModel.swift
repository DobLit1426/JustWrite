//
//  HomeViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 24.09.2023.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    private var logger: AppLogger = AppLogger(subsystem: ".diaryApp", category: "HomeViewViewModel")
    
    init() {
        logger.info("Starting intialising HomeViewViewModel object")
        
        logger.info("Successfully intialised ViewModel object")
    }
}
