//
//  CrashReporter.swift
//  Diary
//
//  Created by Dobromir Litvinov on 30.10.2023.
//

import Foundation
import UIKit


class LogReporter {
    static let logger: AppLogger = AppLogger(category: "Crash")
    
    static func sendLog(type: LogType, title: String, description: String, subsystem: String, category: String) {
        guard let urlString = ProcessInfo.processInfo.environment["MAKE_COM_LOG_REPORT_API"] else {
            print("Couldn't get URL string")
            return
        }
        var deviceInfo: String {
            let device = UIDevice.current
            let model = device.model
            let systemVersion = device.systemVersion
            return "Device Model: \(model)\nFirmware Version: \(systemVersion)"
        }
        
        let parameters: [String: Any] = [
            "Device Model": UIDevice.current.model,
            "Device Firmware": UIDevice.current.systemVersion,
            "Title": title,
            "Description": description,
            "Category": category,
            "Subsystem": subsystem,
            "Type": type.rawValue
        ]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
