//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import XCTest

import EnrichedText

class EnrichedTextColorTests: XCTestCase {
    
    func testRed() {
        guard let color = EnrichedTextColor(string: "red") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, UInt16.max)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testBlue() {
        guard let color = EnrichedTextColor(string: "blue") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, UInt16.max)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testGreen() {
        guard let color = EnrichedTextColor(string: "green") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, UInt16.max)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testYellow() {
        guard let color = EnrichedTextColor(string: "yellow") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, UInt16.max)
        XCTAssertEqual(color.green, UInt16.max)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testCyan() {
        guard let color = EnrichedTextColor(string: "cyan") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, UInt16.max)
        XCTAssertEqual(color.blue, UInt16.max)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testMagenta() {
        guard let color = EnrichedTextColor(string: "magenta") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, UInt16.max)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, UInt16.max)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testBlack() {
        guard let color = EnrichedTextColor(string: "black") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testWhite() {
        guard let color = EnrichedTextColor(string: "white") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, UInt16.max)
        XCTAssertEqual(color.green, UInt16.max)
        XCTAssertEqual(color.blue, UInt16.max)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testInvalidColorName() {
        guard let _ = EnrichedTextColor(string: "babyelephant") else {
            return
        }
        XCTFail()
    }


    func testColorFormat() {
        guard let color = EnrichedTextColor(string: "A123,B456,C789") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0xA123)
        XCTAssertEqual(color.green, 0xB456)
        XCTAssertEqual(color.blue, 0xC789)
        XCTAssertEqual(color.alpha, UInt16.max)
    }

    func testColorFormatWithAlpha() {
        guard let color = EnrichedTextColor(string: "A123,B456,C789,ABCD") else {
            XCTFail()
            return
        }
        XCTAssertEqual(color.red, 0xA123)
        XCTAssertEqual(color.green, 0xB456)
        XCTAssertEqual(color.blue, 0xC789)
        XCTAssertEqual(color.alpha, 0xABCD)
    }

    func testInvalidColorFormatA() {
        guard let _ = EnrichedTextColor(string: "A123,B456C789") else {
            return
        }
        XCTFail()
    }

    func testInvalidColorFormatB() {
        guard let _ = EnrichedTextColor(string: "A123,B456C,789") else {
            return
        }
        XCTFail()
    }

}
