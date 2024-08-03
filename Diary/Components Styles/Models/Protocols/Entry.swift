//
//  Entry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

protocol Entry: Identifiable {
    associatedtype HeadingType
    associatedtype ContentType
    associatedtype DateType
    associatedtype MoodType
    
    var heading: HeadingType { get set }
    var content: ContentType { get set }
    var date: DateType { get set }
    var mood: MoodType { get set }
}
