//
//  AppLogger.swift
//  Diary
//
//  Created by Dobromir Litvinov on 30.10.2023.
//

import Foundation
import os

enum SendReportOption {
    case yes
    case no
    case automatic
}

/// Logger that must be used to log logs, warnings, errors etc.
class AppLogger {
    // MARK: - Static constants
    static let userDefaultsSendAnonymousReportsKey: String = "Settings-SendAnonymousReports"
    static let userDefaultsSendAnonymousReportsDefaultValue: Bool = false
    private let userDefaultsSendAnonymousReportsKey = AppLogger.userDefaultsSendAnonymousReportsKey
    
    // MARK: - Public constants
    public let subsystem: String
    public let category: String
    
    // MARK: - Private constants
    private let systemLogger: Logger
    
    // MARK: - Inits
    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.systemLogger = Logger(subsystem: subsystem, category: category)
    }
    
    convenience init(category: String) {
        self.init(subsystem: ".com.justWrite", category: category)
    }
    
    // MARK: - Public functions
    public func info(_ message: String) {
        systemLogger.info("\(message)")
    }
    
    public func functionBegin(_ functionName: String) {
        systemLogger.info("The function '\(functionName)' is beginning.")
    }
    
    public func functionEnd(_ functionName: String, successfull: Bool = true) {
        if successfull {
            systemLogger.info("The function '\(functionName)' ended successfully.")
        } else {
            systemLogger.warning("The function '\(functionName)' ended with problems.")
        }
    }
    
    public func initBegin() {
        systemLogger.info("The init of the class '\(self.category)' is beginning.")
    }
    
    public func initEnd(successfull: Bool = true) {
        if successfull {
            systemLogger.info("The init of the class '\(self.category)' ended successfully")
        } else {
            systemLogger.warning("The init of the class '\(self.category)' ended with problems.")
        }
    }
    
    public func error(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.error("\(message)")

        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .error, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    public func critical(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.critical("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .critical, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    public func warning(_ message: String, sendReport: SendReportOption = .no) {
        systemLogger.warning("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .warning, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    public func fatalError(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.critical("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .fatalError, title: "Fatal error", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    public func reportableLog(logType: LogType, title: String, message: String, sendReport: SendReportOption = .automatic) {
        switch logType {
        case .warning:
            systemLogger.warning("\(message)")
        case .error:
            systemLogger.error("\(message)")
        default:
            systemLogger.critical("\(message)")
        }
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: logType, title: title, description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    // MARK: - Private functions
    private func sendReportBasedOn(sendReport: SendReportOption, sendReportAction: () -> Void) {
        if sendReport == .yes {
            sendReportAction()
        } else if sendReport == .automatic && UserDefaultsInteractor.getSendAnonymousReportsValue() {
            sendReportAction()
        }
    }
}
