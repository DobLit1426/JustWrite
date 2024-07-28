//
//  SortingMenu.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.11.2023.
//

import SwiftUI

struct SortingMenu: View {
    @Binding var sortingTechnique: DiaryEntriesSortingTechnique
    
    var body: some View {
        Menu {
            ForEach(DiaryEntriesSortingTechnique.allCases, id: \.localized) { technique in
                Button {
                    sortingTechnique = technique
                } label: {
                    HStack {
                        Text(technique.localized).tag(technique)
                        if technique.localized == sortingTechnique.localized {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}

#Preview {
   @State var sortingTechnique: DiaryEntriesSortingTechnique = .higherMoodAtTop
                
   return SortingMenu(sortingTechnique: $sortingTechnique)
}
