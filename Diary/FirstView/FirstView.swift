//
//  FirstView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.09.2023.
//

import SwiftUI
import SwiftData
import os

struct FirstView: View {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "FirstView")
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var swiftDataContext
    
    @Query private var settings: [Settings]
    
    private var viewModel: FirstViewModel
    
    @State var currentView: CurrentView = .none
    @State var isUnlocked: Bool = false
    @State var determiniedInitialView: Bool = false
    
    init() {
        logger.info("Initialising FirstView...")
        viewModel = FirstViewModel()
        logger.info("Successfully intitalised FirstView")
    }
    
    var body: some View {
        ZStack {
            switch currentView {
            case .appSetup:
                AppSetupView(currentView: $currentView)
            case .diary:
                NavigationManager()
            default:
//                Text("The specified currentView '\(currentView.rawValue)' isn't included in Switch in FirstView")
                EmptyView()
            }
            
            if !isUnlocked {
                Rectangle().foregroundStyle(.white)
                AuthenticationView(isUnlocked: $isUnlocked)
            }
        }
        .onAppear {
            logger.info("FirstView appeared")
            logger.info("Starting doing functions on the appear of FirstView...")
            onAppear()
            logger.info("Successfully finished doing functions on the appear of FirstView appear")
        }
        .animation(.easeInOut, value: currentView)
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == ScenePhase.background {
                lockTheApp()
            }
        }
    }
    
    private func lockTheApp() {
        logger.info("Starting function to lock the app...")
        isUnlocked = false
        logger.info("Successfully locked the app")
    }
    
    private func onAppear() {
        if !determiniedInitialView {
            onFirstAppear()
        }
    }
    
    private func onFirstAppear() {
        logger.info("Starting onFirstAppear function...")
        
        checkSettings()
        
        viewModel.update(with: settings)
        
        let determinedInitialView = viewModel.determineInitialView()
        logger.info("Determined initial view is \(determinedInitialView.rawValue)")
        if determinedInitialView == .appSetup {
            isUnlocked = true
            currentView = .appSetup
        } else if determinedInitialView == .diary {
            isUnlocked = true
            currentView = .diary
        } else if determinedInitialView == .authentication {
            isUnlocked = false
            currentView = .diary
        } else {
            logger.critical("Determined initial view ('\(determinedInitialView.rawValue)') isn't included in if-else, setting currentView to '.none' and unlocked to 'true'")
            isUnlocked = true
            currentView = .none
        }
        
        determiniedInitialView = true
        
        logger.info("Successfully finished onFirstAppear function")
    }
    
    private func checkSettings() {
        logger.info("Starting function to check settings...")
        if settings.count > 1 {
            logger.critical("Found multiple settings instances. Deleting all them except the last one to continue app functionality...")
            for index in 0..<settings.count - 1 {
                swiftDataContext.delete(settings[index])
            }
            logger.critical("Deleted all settings instances except the last one. The last settings instance will be the saved.")
        } else {
            logger.info("Successfully checked settings")
        }
    }
}


#Preview {
    FirstView()
}
