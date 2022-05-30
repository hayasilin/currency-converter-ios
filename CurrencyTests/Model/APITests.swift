//
//  APITests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation

class APITests {
    static func testDataFromJSON(fileName: String) throws -> Data? {
        let path = Bundle(for: self).path(forResource: fileName, ofType: "json")!
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
