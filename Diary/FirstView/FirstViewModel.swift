//
//  FirstViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.09.2023.
//

import Foundation
import os

/// ViewModel of FirstView
class FirstViewModel: ObservableObject {
    /// Logger instance
    private var logger: Logger = Logger(subsystem: ".diaryApp", category: "FirstViewModel")

    // MARK: - @Published variables
    /// Settings objects
    @Published var settings: [Settings]
    
    // MARK: - Init
    /// Initialises the viewModel by setting the settings to an empty array
    init() {
        logger.info("Starting intialising FirstViewModel object...")
        
        settings = []
        
        logger.info("Successfully intialised FirstViewModel object")
    }
    
    // MARK: - Public functions
    /// Determines the initial View based on the settings
    func determineInitialView() -> InitialView {
        logger.info("Starting function to detemine the initial View...")
        
        var viewToReturn: InitialView = .appSetup
        
        if settings.count > 1 {
            logger.critical("Multiply settings instances found. Returning .diary View")
            viewToReturn = .diary
        } else if settings.count == 1 {
            if settings[0].authenticateWithBiometricData == true {
                viewToReturn = .authentication
            } else {
                viewToReturn = .diary
            }
        } else {
            viewToReturn = .appSetup
        }
        
        logger.info("Successfully determined initial View")
        return viewToReturn
    }
    
    /// Updates the viewModel with settings array
    func update(with settings: [Settings]) {
        logger.info("Starting function to update self.settings...")
        self.settings = settings
        logger.info("Successfully updated self.settings")
    }
}
