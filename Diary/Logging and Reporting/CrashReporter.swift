//
//  CrashReporter.swift
//  Diary
//
//  Created by Dobromir Litvinov on 30.10.2023.
//

import Foundation
import UIKit

enum LogType: String {
    case warning = "Warning"
    case error = "Error"
    case critical = "Critical"
    case fatalError = "Fatal error"
}

// https://maker.ifttt.com/trigger/justwrite_log/json/with/key/jRz7Be2KJuSJWkKjnexKP4XLR982gvtw8ehvRo1Ejip
// https://hook.eu2.make.com/9h6w2ke20527l584pcuw5avs1di8l15x
//curl -X POST https://hook.eu2.make.com/9h6w2ke20527l584pcuw5avs1di8l15x \
//-H "Content-Type: application/json" \
//-d '{
//    "Title": "Title",
//    "Description": "",
//    "Device Model": "",
//    "Device Firmware": "",
//    "Subsystem": "",
//    "Category": "",
//    "Type": ""
//}'

// Pipedream 25 http request per day - https://eou42t3u6ow47x1.m.pipedream.net
// make.com - as many as I want requests per day - https://hook.eu2.make.com/9h6w2ke20527l584pcuw5avs1di8l15x

class CrashReporter {
    static func sendLog(type: LogType, title: String, description: String, subsystem: String, category: String) {
//        guard let urlString = ProcessInfo.processInfo.environment["reportLogsUrlApi"] else {
//            return
//        }
        let urlString = "https://hook.eu2.make.com/9h6w2ke20527l584pcuw5avs1di8l15x"
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
