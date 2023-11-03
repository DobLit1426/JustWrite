//
//  MarkdownText.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.10.2023.
//

import SwiftUI

/// Shows specified Text based on the Markdown used
struct MarkdownText: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "MarkdownText")
    
    // MARK: - Markdown Titles prefixes
    /// Prefix for the title size 1
    private let title1Prefix: String = "# "
    
    /// Prefix for the title size 2
    private let title2Prefix: String = "## "
    
    /// Prefix for the title size 3
    private let title3Prefix: String = "### "
    
    // MARK: - Private variables
    /// Shows whether the provided string has a markdown syntax for title
    private var isTitle: Bool
    
    // MARK: - Private constants
    /// Provided text
    private let text: String
    
    /// Localized text from the provided text
    private let localizedText: LocalizedStringKey
    
    // MARK: - Init
    init(text: String) {
        self.text = text
        self.localizedText = LocalizedStringKey(text + " ")
        self.isTitle = text.hasPrefix(title1Prefix) || text.hasPrefix(title2Prefix) || text.hasPrefix(title3Prefix)
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if isTitle {
                Group {
                    if text.hasPrefix(title1Prefix) {
                        Text(LocalizedStringKey(String(text.dropFirst(title1Prefix.count))))
                            .font(.largeTitle)
                    } else if text.hasPrefix(title2Prefix) {
                        Text(LocalizedStringKey(String(text.dropFirst(title2Prefix.count))))
                            .font(.title)
                    } else if text.hasPrefix(title3Prefix) {
                        Text(LocalizedStringKey(String(text.dropFirst(title3Prefix.count))))
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .headline).pointSize * 1.2))
                    }
                }
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
            } else {
                Text(localizedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .textSelection(.enabled)
    }
}

#Preview {
    MarkdownText(text: """
# Title 1
## Title 2
### Title 3
**Some bold text**
*Some cursive text*
***Bold and cursive text***
~Strikethrough text~
~~Strikethrough text 2~~
`Monospaced text`
""")
}
