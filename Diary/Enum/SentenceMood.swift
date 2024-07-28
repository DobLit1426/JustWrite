//
//  SentenceMood.swift
//  Diary
//
//  Created by Dobromir Litvinov on 22.11.2023.
//

import Foundation

struct SentenceMood {
    let sentenceNumber: Int
    let mood: Int
    
    init(sentenceNumber: Int, mood: Int) {
        self.sentenceNumber = sentenceNumber
        self.mood = mood
    }
}
