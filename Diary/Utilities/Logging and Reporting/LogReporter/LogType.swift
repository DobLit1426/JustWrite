//
//  LogType.swift
//  Diary
//
//  Created by Dobromir Litvinov on 03.11.2023.
//

import Foundation

/// Specifies type of app log
enum LogType: String {
    /// Typically used to indicate a potential issue or anomaly that may not prevent the application from functioning but should be addressed to ensure smooth operation.
    /// - Example: Suppose you have an e-commerce app, and a user adds an item to their cart, but there is a delay in updating the cart due to a slow database query. You might log a warning message like this: "Warning: Cart update delayed due to slow database query."
    case warning = "Warning"
    
    /// Used to report a problem or unexpected condition that has occurred. It indicates that the application encountered an issue but can potentially recover from it without crashing.
    /// - Example:  In a messaging app, if a message fails to send because of a network error, you might log an error message like this: "Error: Message not sent due to network connection issue."
    case error = "Error"
    
    /// Used for severe issues that may severely impact the application's functionality but still allow the application to continue running. It signifies a significant problem that needs immediate attention.
    /// - Example:  In a financial app, if a critical component responsible for processing transactions encounters an issue, you might log a critical error like this: "Critical Error: Payment processing component failure."
    case critical = "Critical"
    
    /// The most serious type of log entry. It signifies a catastrophic issue that makes it impossible for the application to continue running. The application is likely to crash or become unresponsive when a fatal error occurs.
    /// - Example:  If a memory corruption or segmentation fault occurs in your application, it might result in a fatal error like this: "Fatal Error: Application crashed due to a memory access violation."
    case fatalError = "Fatal error"
}
