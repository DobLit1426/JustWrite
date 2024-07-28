//
//  DataUsedForAnonymousReports.swift
//  Diary
//
//  Created by Dobromir Litvinov on 31.10.2023.
//

import SwiftUI

fileprivate struct CollectedData: Identifiable {
    let id: UUID
    let dataType: String
    let example: String
    
    init(dataType: String, example: String) {
        self.id = UUID()
        self.dataType = dataType
        self.example = example
        
    }
}

struct WhatAreAnonymousReports: View {
    private let collectedData: [CollectedData] = [
        CollectedData(dataType: "Type of your device", example: "iPhone"),
        CollectedData(dataType: "Firmware version of your device", example: "iOS 17.1"),
        CollectedData(dataType: "Type of the reported error", example: "Critical error"),
        CollectedData(dataType: "Title of the reported error", example: "Authentication with FaceID is called although not available"),
        CollectedData(dataType: "Description of the reported error", example: "Authentication with FaceID is called although FaceID is not set up, unlocking app because no authentication methods are available"),
        CollectedData(dataType: "Part of the app where the error occured", example: "Subsystem: .com.JustWrite, Category: AuthenticationView"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        Text("What are Anonymous Reports?")
                            .font(.headline)
                        Text("Anonymous Reports are automatically generated messages containing anonymous data that are sent to a remote server in the event of a crash or error.")
                        Divider()
                        Text("Why should I enable Anonymous Reports?")
                            .font(.headline)
                        Text("If Anonymous Reports are enabled, they will assist developers in finding bugs and errors more quickly. This, in turn, will result in faster resolution of these issues, ultimately enhancing the app's performance.")
                        Divider()
                        Text("What type of data is collected?")
                            .font(.headline)
                        Text("Here you can find all the data that is sent in anonymous reports. For each data type there's an example.")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    HStack {
                        Text("")
                            .frame(maxWidth: 10, alignment: .leading)
                            .padding(.trailing, 6)
//                        Divider()
                        Spacer()
                        Text("Data type")
                            .frame(maxWidth: 130, alignment: .center)
                        Spacer()
//                        Divider()
//                        Spacer()
                        Text("Example")
                            .frame(maxWidth: 130, alignment: .center)
                            .italic()
                        Spacer()
                    }
                    .font(.headline)
                    Divider()
                    ForEach(Array(collectedData.enumerated()), id: \.offset) { index, data in
                        HStack {
                            Text("\(index + 1)")
                                .frame(maxWidth: 10, alignment: .leading)
                                .padding(.trailing, 6)
                            Divider()
                            //                            Spacer()
                            
                            Text(data.dataType)
                                .frame(maxWidth: 135, alignment: .leading)
                                .bold()
                            Spacer()
                            Divider()
                            Spacer()
                            Text(data.example)
                                .frame(maxWidth: 135, alignment: .leading)
                                .italic()
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("Anonymous Reports")
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    WhatAreAnonymousReports()
}
