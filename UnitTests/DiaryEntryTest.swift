//
//  DiaryEntryTest.swift
//  Diary
//
//  Created by Dobromir Litvinov on 05.11.2023.
//

import XCTest
@testable import Diary

final class DiaryEntryTest: XCTestCase {
    var headings = [String]()
    var contents = [String]()
    var ids = [UUID]()
    var dates = [Date]()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testEntryProperties() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        for _ in 1...100 {
            headings.append(randomString())
            contents.append(randomString())
            ids.append(UUID())
            dates.append(Date.now)
        }
        
        for index in 0..<headings.count {
            let heading = headings[index]
            let content = contents[index]
            let date = dates[index]
            let id = ids[index]
            
            let entry = DiaryEntry(heading: heading, content: content, date: date, id: id)
            
            XCTAssert(entry.heading == heading)
            XCTAssert(entry.content == content)
            XCTAssert(entry.date == date)
            XCTAssert(entry.id == id)
        }
        
        headings = []
        contents = []
        ids = []
        dates = []
        
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let heading = randomString()
        let content = randomString()
        let date = Date.now
        let id = UUID()
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = DiaryEntry(heading: heading, content: content, date: date, id: id)
        }
    }
    
    func randomString(length: Int = 0) -> String {
        var lengthToUse = length
        if length <= 0 {
            lengthToUse = Int.random(in: 1...100)
        }
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<lengthToUse).map{ _ in letters.randomElement()! })
    }
}
