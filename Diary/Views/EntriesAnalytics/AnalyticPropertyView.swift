//
//  AnalyticProperty.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.10.2023.
//

import SwiftUI

struct AnalyticPropertyView: View {
    let propertyName: String
    let value: String
    
    var body: some View {
        HStack {
            Text(propertyName)
            Spacer().frame(minWidth: 10)
            Text(value)
        }
    }
    
    init(propertyName: String, value: Double) {
        self.propertyName = propertyName
        self.value = AnalyticPropertyView.roundToTwoDecimalPlaces(number: value)
    }
    
    init(propertyName: String, value: Int) {
        self.propertyName = propertyName
        self.value = String(value)
    }
    
    init(propertyName: String, value: String) {
        self.propertyName = propertyName
        self.value = value
    }
    
    private static func roundToTwoDecimalPlaces(number: Double) -> String {
        let multiplier = pow(10.0, 2.0)
        let roundedNumber = round(number * multiplier) / multiplier
        return String(roundedNumber)
    }
}

#Preview {
    List {
        AnalyticPropertyView(propertyName: "Number of texts", value: 2921)
        AnalyticPropertyView(propertyName: "Number of words", value: 203234)
        AnalyticPropertyView(propertyName: "Average mood", value: 0.92111028123)
    }
}
