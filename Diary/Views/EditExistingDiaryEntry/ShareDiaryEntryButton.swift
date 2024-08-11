//
//  ShareDiaryEntryButton.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.11.2023.
//

import SwiftUI
import UIKit

struct ShareDiaryEntryButton: View {
    let diaryEntry: DiaryEntry
    
    init(diaryEntry: DiaryEntry) {
        self.diaryEntry = diaryEntry
    }
    
    var body: some View {
        VStack {
            //            Menu {
            //                ShareLink("Share plain text", item: shareItem)
            //            } label: {
            //                Image(systemName: "square.and.arrow.up")
            //            }
            
            Menu {
                Button("Share plain text") {
                    shareDiaryEntry()
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
    }
    
    var shareItem: String {
        return diaryEntry.debugDescription
    }
    
    func shareDiaryEntry() {
        let textToShare = [shareItem]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        // For iPad: Provide a source for the popover to prevent a crash
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = UIApplication.shared.windows.first
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Present the activity view controller
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

#Preview {
    NavigationStack {
        ShareDiaryEntryButton(diaryEntry: DebugDummyValues.diaryEntry())
    }
}
