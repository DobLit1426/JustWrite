//
//  FirstViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.09.2023.
//

import Foundation
import CryptoKit
import os

class FirstViewModel: ObservableObject {
    private var logger: Logger = Logger(subsystem: ".diaryApp", category: "FirstViewModel")

    @Published var settings: [Settings]
    
    init(settings: [Settings] = []) {
        logger.info("Starting intialising FirstViewModel object...")
        
        self.settings = settings
        
        logger.info("Successfully intialised FirstViewModel object")
    }
    
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
    
    func update(with settings: [Settings]) {
        logger.info("Starting function to update self.settings...")
        self.settings = settings
        logger.info("Successfully updated self.settings")
    }
}
