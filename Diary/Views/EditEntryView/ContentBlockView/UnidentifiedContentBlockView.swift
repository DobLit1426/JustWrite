//
//  UnidentifiedContentBlockView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.08.24.
//

import SwiftUI

struct UnidentifiedContentBlockView: View, Equatable {
    var body: some View {
        ContentUnavailableView("Unfortunately this block couldn't load", image: "exclamationmark.warninglight")
    }
}


#Preview {
    UnidentifiedContentBlockView()
}
