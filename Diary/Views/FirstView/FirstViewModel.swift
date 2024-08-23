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
    // MARK: - Logger
    /// Logger instance
    private var logger: AppLogger = AppLogger(category: "FirstViewModel")

    // MARK: - @Published variables
    /// Settings objects
    @Published var settings: [Settings]
    
    // MARK: - Init
    /// Initialises the viewModel by setting the settings to an empty array
    init() {
        logger.initBegin()
        
        settings = []
        
        logger.initEnd()
    }
    
    // MARK: - Public functions
    /// Determines the initial View based on the settings
    func determineInitialView() -> InitialView {
        logger.info("Starting function to detemine the initial View...")
        
        var viewToReturn: InitialView = .appSetup
        
        if settings.count > 1 {
            logger.error("Multiply settings instances found. Returning .diary View", sendReport: .no)
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
        
        logger.info("Successfully determined initial View: \(viewToReturn.rawValue)")
        return viewToReturn
    }
    
    /// Updates the viewModel with settings array
    func update(with settings: [Settings]) {
        logger.info("Starting function to update self.settings...")
        self.settings = settings
        logger.info("Successfully updated self.settings")
    }
    
    func shouldLockTheApp(_ settings: [Settings]) -> Bool {
        update(with: settings)
        
        if settings.count == 1 {
            if settings[0].authenticateWithBiometricData == true { return true }
        }
        
        return false
    }
}
