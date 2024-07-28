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
    static let userDefaultsSendAnonymousReportsKey: String = "Settings-SendAnonymousReports"
    static let userDefaultsSendAnonymousReportsDefaultValue: Bool = false
    private let userDefaultsSendAnonymousReportsKey = AppLogger.userDefaultsSendAnonymousReportsKey
    
    let subsystem: String
    let category: String
    
    private let systemLogger: Logger
    
    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.systemLogger = Logger(subsystem: subsystem, category: category)
    }
    
    init(category: String) {
        self.subsystem = ".com.justWrite"
        self.category = category
        self.systemLogger = Logger(subsystem: subsystem, category: category)
    }
    
    func error(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.error("\(message)")

        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .error, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    func info(_ message: String) {
        systemLogger.info("\(message)")
    }
    
    func critical(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.critical("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .critical, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    func warning(_ message: String, sendReport: SendReportOption = .no) {
        systemLogger.warning("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .warning, title: "", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    func fatalError(_ message: String, sendReport: SendReportOption = .automatic) {
        systemLogger.critical("\(message)")
        
        sendReportBasedOn(sendReport: sendReport, sendReportAction: {
            LogReporter.sendLog(type: .fatalError, title: "Fatal error", description: "\(message)", subsystem: self.subsystem, category: self.category)
        })
    }
    
    func reportableLog(logType: LogType, title: String, message: String, sendReport: SendReportOption = .automatic) {
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
    
    private func sendReportBasedOn(sendReport: SendReportOption, sendReportAction: () -> Void) {
        if sendReport == .yes {
            sendReportAction()
        } else if sendReport == .automatic && UserDefaultsInteractor.getSendAnonymousReportsValue() {
            sendReportAction()
        }
    }
}
