//
//  ContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation
import SwiftData

protocol ContentBlock: Codable, Identifiable, Equatable {
    associatedtype TypeOfTheContentOfTheBlock
    
//    var type: ContentBlockType { get }
    var content: TypeOfTheContentOfTheBlock { get set }
    var id: UUID { get set }
}
