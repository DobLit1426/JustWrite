//
//  FirstView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.09.2023.
//

import SwiftUI
import SwiftData

/// Used to control which app part is shown
struct FirstView: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: AppLogger = AppLogger(category: "FirstView")
    
    // MARK: - @Environment variables
    /// Describes the current scene phase
    @Environment(\.scenePhase) var scenePhase
    
    /// Swift Data context
    @Environment(\.modelContext) private var swiftDataContext
    
    // MARK: - @Query variables
    /// Settings objects that are automatically fetched and updated by Swift Data
    @Query private var settings: [Settings]
    
    // MARK: - ViewModel
    /// View model
    @StateObject private var viewModel: FirstViewModel = FirstViewModel()
    
    // MARK: - State Variables
    /// Stores the enum value of the current view
    @State var currentView: CurrentView = .none
    
    /// Determines whether the app is unlocked or not
    @State var isUnlocked: Bool = false
    
    /// If true, the function on the first appear will be called. If false, not.
    /// - Important: When the function on first appear is done, this value is set to true.
    @State var determiniedInitialView: Bool = false
    
    // MARK: - Init
    /// Initialises the struct by creating viewModel
    init() {
        logger.initBegin()
        
        logger.initEnd()
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Group {
                if determiniedInitialView {
                    switch currentView {
                    case .appSetup:
                        AppSetupView(currentView: $currentView)
                    case .diary:
                        NavigationManager()
                    default:
                        EmptyView()
                            .onAppear {
                                logger.fatalError("The specified currentView '\(currentView.rawValue)' isn't included in Switch in FirstView")
                                fatalError() // A fatal error here to draw the attention if some currentView value isn't included in the switch
                            }
                    }
                }
            }
            .opacity(isUnlocked ? 1 : 0)
            .disabled(!isUnlocked)
            
            if !isUnlocked { AuthenticationView(isUnlocked: $isUnlocked) }
        }
        .onAppear { onAppear() }
        .animation(.easeInOut, value: currentView)
        .animation(.easeInOut.delay(0.01), value: isUnlocked)
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background {
                if viewModel.shouldLockTheApp(settings) {
                    lockTheApp()
                }
            }
        }
    }
    
    // MARK: - Private functions
    /// Locks the app
    private func lockTheApp() {
        let functionName = "lockTheApp()"
        logger.functionBegin(functionName)
        
        isUnlocked = false
        logger.info("Successfully locked the app")
        
        logger.functionEnd(functionName)
    }
    
    /// Called on View appear. Checks whether the View appears for the first time and if yes, then calls onFirstAppear
    private func onAppear() {
        let functionName = "onAppear()"
        logger.functionBegin(functionName)
        
        if !determiniedInitialView {
            onFirstAppear()
        }
        
        logger.info("Successfully finished doing functions on the appear of FirstView appear")
        logger.functionEnd(functionName)
    }
    
    /// Function called on the first View appear. Checks setting, updates viewModel, determines and sets the initial View.
    private func onFirstAppear() {
        let functionName = "onFirstAppear()"
        logger.functionBegin(functionName)
        
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
        
        logger.functionEnd(functionName)
    }
    
    /// Checks settings objects. If finds multiple, deletes all except the last.
    private func checkSettings() {
        let functionName = "checkSettings()"
        logger.functionBegin(functionName)
        
        if settings.count > 1 {
            logger.critical("Found multiple settings instances. Deleting all them except the last one to continue app functionality...")
            
            for index in 0..<settings.count - 1 {
                swiftDataContext.delete(settings[index])
            }
            
            logger.critical("Deleted all settings instances except the last one. The last settings instance will be the saved.")
        }
        
        
        logger.info("Checked settings. Number of settings: \(settings.count)")
        logger.functionEnd(functionName)
    }
}


#Preview {
    FirstView()
}
