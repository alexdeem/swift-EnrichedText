//  Copyright (c) 2018 Tabcorp Pty. Ltd. All rights reserved.

import XCTest
import EnrichedText

class Tests: XCTestCase {

    func testPlainText() {
        let enrichedText = try! EnrichedText(string: "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 1)
        XCTAssertEqual(enrichedText.components[0].text, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
    }

    func testEmoji() {
        let enrichedText = try! EnrichedText(string: "The 🐈 sat on the 🎩.")
        XCTAssertEqual(enrichedText.plainText, "The 🐈 sat on the 🎩.")
        XCTAssertEqual(enrichedText.components.count, 1)
        XCTAssertEqual(enrichedText.components[0].text, "The 🐈 sat on the 🎩.")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
    }

    func testBoldText() {
        let enrichedText = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.bold])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testNesting() {
        let enrichedText = try! EnrichedText(string: "The <bold>cat <italic><underline>sat</underline></italic></bold> on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 4)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat ")
        XCTAssertEqual(enrichedText.components[1].style.options, [.bold])
        XCTAssertEqual(enrichedText.components[2].text, "sat")
        XCTAssertEqual(enrichedText.components[2].style.options, [.bold,.italic,.underline])
        XCTAssertEqual(enrichedText.components[3].text, " on the hat.")
        XCTAssertEqual(enrichedText.components[3].style.options, [])
    }

    func testLeadingCommand() {
        let enrichedText = try! EnrichedText(string: "<bold>The cat</bold> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 2)
        XCTAssertEqual(enrichedText.components[0].text, "The cat")
        XCTAssertEqual(enrichedText.components[0].style.options, [.bold])
        XCTAssertEqual(enrichedText.components[1].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
    }

    func testTrailingCommand() {
        let enrichedText = try! EnrichedText(string: "The cat sat on <bold>the hat.</bold>")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 2)
        XCTAssertEqual(enrichedText.components[0].text, "The cat sat on ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "the hat.")
        XCTAssertEqual(enrichedText.components[1].style.options, [.bold])
    }

    func testUnrecognisedCommand() {
        let enrichedText = try! EnrichedText(string: "The <bold>cat</bold> sat on <foobar>the</foobar> hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 5)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.bold])
        XCTAssertEqual(enrichedText.components[2].text, " sat on ")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[3].text, "the")
        XCTAssertEqual(enrichedText.components[3].style.options, [])
        XCTAssertEqual(enrichedText.components[4].text, " hat.")
        XCTAssertEqual(enrichedText.components[4].style.options, [])
    }

    func testUnterminatedCommand() {
        let string = "The cat sat on the <bol"
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "Unterminated Command")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 23)
        } catch {
            XCTFail()
        }
    }

    func testEscapedLessThan() {
        let enrichedText = try! EnrichedText(string: "12 << 100")
        XCTAssertEqual(enrichedText.plainText, "12 < 100")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testEscapedTags() {
        let enrichedText = try! EnrichedText(string: "The <<bold>cat<</bold> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The <bold>cat</bold> sat on the hat.")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testInvalidCommand() {
        let string = "The cat <b@d>sat</b@d> on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "Unexpected Character in Command")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 10)
        } catch {
            XCTFail()
        }
    }

    func testMixedCaseCommand() {
        let enrichedText = try! EnrichedText(string: "The <bOlD>cat</BoLD> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.bold])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testCommandWithParam() {
        let enrichedText = try! EnrichedText(string: "The <color><param>red</param>cat</color> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testUnterminatedParam() {
        let string = "The <color><param>red</color> sat on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "Expected </param> not found")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 18)
        } catch {
            XCTFail()
        }
    }

    func testSingleNewLine() {
        let enrichedText = try! EnrichedText(string: "The cat\nsat on\nthe hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testMultipleNewLine() {
        let enrichedText = try! EnrichedText(string: "The cat sat on the hat.\n\nThe hat went flat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.\nThe hat went flat.")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testNoFill() {
        let enrichedText = try! EnrichedText(string: "<nofill>The cat sat on the hat.\nThe hat went flat.\n\n</nofill>I do not like\ngreen eggs and ham.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.\nThe hat went flat.\n\nI do not like green eggs and ham.")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testNestedNoFill() {
        let enrichedText = try! EnrichedText(string: "<nofill>The cat sat on<nofill> the hat.\nThe hat went</nofill> flat.\n\n</nofill>I do not like\ngreen eggs and ham.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.\nThe hat went flat.\n\nI do not like green eggs and ham.")
        for component in enrichedText.components {
            XCTAssertEqual(component.style.options, [])
        }
    }

    func testUnbalancedCommands() {
        let string = "The <bold><italic>red</bold></italic> sat on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "Unbalanced Command Tag")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 23)
        } catch {
            XCTFail()
        }
    }

    static let complexExample = """
        <bold>Now</bold> is the time for <italic>all</italic>
        good men
        <smaller>(and <<women>)</smaller> to
        <ignoreme>come</ignoreme>

        to the aid of their


        <color><param>red</param>beloved</color>
        country.

        By the way,
        I think that <paraindent><param>left</param><<smaller>

        </paraindent>should REALLY be called

        <paraindent><param>left</param><<tinier></paraindent>

        and that I am always right.

        -- the end
        """
    static let complexExpectedOutput = """
        Now is the time for all good men (and <women>) to come
        to the aid of their

        beloved country.
        By the way, I think that <smaller>
        should REALLY be called
        <tinier>
        and that I am always right.
        -- the end
        """

    func testComplex() {
        let enrichedText = try! EnrichedText(string: Tests.complexExample)
        let expected = Tests.complexExpectedOutput
        XCTAssertEqual(enrichedText.plainText, expected)
    }

    func testCustomStringConvertible() {
        let enrichedText = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        XCTAssertEqual(enrichedText.description, "The <bold>cat</bold> sat on the hat.")
    }

    func testExpressibleByStringLiteral() {
        let textA : EnrichedText = "The <bold>cat</bold> sat on the hat."
        let textB = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        XCTAssertEqual(textA, textB)
    }

    func testEquatable() {
        let textA = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        let textB = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        XCTAssertEqual(textA, textB)
        let textC = try! EnrichedText(string: "The cat sat on the hat.")
        XCTAssertNotEqual(textB, textC)
        let textD = textC
        XCTAssertEqual(textC, textD)
        XCTAssertEqual(textC, textC)
    }

    func testHashable() {
        let textA = try! EnrichedText(string: "The <bold>cat</bold> sat on the hat.")
        let textB = try! EnrichedText(string: "The cat sat on the hat.")
        let dictionary = [textA : "A", textB : "B"]
        XCTAssertEqual(dictionary[textA], "A")
        XCTAssertEqual(dictionary[textB], "B")
    }

    func testEncoding() {
        let string = "The <bold>cat</bold> sat on the hat."
        let enrichedText = try! EnrichedText(string: string)
        let jsonData = try! JSONEncoder().encode(["a":enrichedText])
        let expectedData = try! JSONEncoder().encode(["a":string])
        XCTAssertEqual(jsonData, expectedData)
    }

    func testDecoding() {
        let string = "The <bold>cat</bold> sat on the hat."
        let jsonString = "{\"a\":\"\(string)\"}"
        let jsonData = jsonString.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String:EnrichedText].self, from: jsonData)
        let expectedEnhancedText = try! EnrichedText(string:string)
        XCTAssertEqual(object["a"], expectedEnhancedText)
    }

    func testInitPerformance() {
        self.measure {
            for _ in 1...5000 {
                _ = try! EnrichedText(string: Tests.complexExample)
            }
        }
    }

}
