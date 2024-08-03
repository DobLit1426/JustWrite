//
//  ContentBlock.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation
import SwiftData

protocol ContentBlock: Codable {
    associatedtype TypeOfTheContentOfTheBlock
    
    var type: ContentBlockType { get }
    var content: TypeOfTheContentOfTheBlock { get set }
}
