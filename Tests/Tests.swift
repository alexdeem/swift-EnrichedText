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

    func testBold() {
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

    func testItalic() {
        let enrichedText = try! EnrichedText(string: "The <italic>cat</italic> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.italic])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testUnderline() {
        let enrichedText = try! EnrichedText(string: "The <underline>cat</underline> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.underline])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testFixed() {
        let enrichedText = try! EnrichedText(string: "The <fixed>cat</fixed> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [.fixed])
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
    }

    func testFontFamily() {
        let enrichedText = try! EnrichedText(string: "The <fontfamily><param>times</param>cat</fontfamily> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.fontFamily, nil)
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.fontFamily, "times")
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.fontFamily, nil)
    }

    func testColor() {
        let enrichedText = try! EnrichedText(string: "The <color><param>red</param>cat</color> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.color, nil)
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.color, EnrichedTextColor(string: "red"))
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.color, nil)
    }

    func testSmaller() {
        let enrichedText = try! EnrichedText(string: "The <smaller>cat</smaller> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.relativeFontSize, 0)
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.relativeFontSize, -1)
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.relativeFontSize, 0)
    }

    func testNestedSmaller() {
        let enrichedText = try! EnrichedText(string: "The <smaller>cat <smaller>sat</smaller></smaller> on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 4)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.relativeFontSize, 0)
        XCTAssertEqual(enrichedText.components[1].text, "cat ")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.relativeFontSize, -1)
        XCTAssertEqual(enrichedText.components[2].text, "sat")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.relativeFontSize, -2)
        XCTAssertEqual(enrichedText.components[3].text, " on the hat.")
        XCTAssertEqual(enrichedText.components[3].style.options, [])
        XCTAssertEqual(enrichedText.components[3].style.relativeFontSize, 0)
    }

    func testBigger() {
        let enrichedText = try! EnrichedText(string: "The <bigger>cat</bigger> sat on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 3)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.relativeFontSize, 0)
        XCTAssertEqual(enrichedText.components[1].text, "cat")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.relativeFontSize, 1)
        XCTAssertEqual(enrichedText.components[2].text, " sat on the hat.")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.relativeFontSize, 0)
    }

    func testNestedBigger() {
        let enrichedText = try! EnrichedText(string: "The <bigger>cat <bigger>sat</bigger></bigger> on the hat.")
        XCTAssertEqual(enrichedText.plainText, "The cat sat on the hat.")
        XCTAssertEqual(enrichedText.components.count, 4)
        XCTAssertEqual(enrichedText.components[0].text, "The ")
        XCTAssertEqual(enrichedText.components[0].style.options, [])
        XCTAssertEqual(enrichedText.components[0].style.relativeFontSize, 0)
        XCTAssertEqual(enrichedText.components[1].text, "cat ")
        XCTAssertEqual(enrichedText.components[1].style.options, [])
        XCTAssertEqual(enrichedText.components[1].style.relativeFontSize, 1)
        XCTAssertEqual(enrichedText.components[2].text, "sat")
        XCTAssertEqual(enrichedText.components[2].style.options, [])
        XCTAssertEqual(enrichedText.components[2].style.relativeFontSize, 2)
        XCTAssertEqual(enrichedText.components[3].text, " on the hat.")
        XCTAssertEqual(enrichedText.components[3].style.options, [])
        XCTAssertEqual(enrichedText.components[3].style.relativeFontSize, 0)
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
            XCTAssertEqual(characters, 28)
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
    static let complexMixedCaseExample = """
        <BoLd>Now</bOLd> is the time for <itaLIc>all</ItalIc>
        good men
        <sMAllER>(and <<women>)</smallER> to
        <iGNoreme>come</ignoREME>

        to the aid of their


        <COlor><PARAm>red</paRAM>beloved</coLOr>
        country.

        By the way,
        I think that <paRAindeNT><paRAm>left</pARAm><<smaller>

        </paraIndent>should REALLY be called

        <paraINDent><paRam>left</pAram><<tinier></paRAIndent>

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

    func testComplexMixedCase() {
        let enrichedText = try! EnrichedText(string: Tests.complexMixedCaseExample)
        let expected = Tests.complexExpectedOutput
        XCTAssertEqual(enrichedText.plainText, expected)
    }

    func testMissingColorParam() {
        let string = "The <color>cat</color> sat on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "color command requires param")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 11)
        } catch {
            XCTFail()
        }
    }

    func testMissingFontFamilyParam() {
        let string = "The <fontfamily>cat</fontfamily> sat on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "fontfamily command requires param")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 16)
        } catch {
            XCTFail()
        }
    }

    func testInvalidParam() {
        let string = "The <color><param>burgandy</param>cat</color> sat on the hat."
        do {
            _ = try EnrichedText(string: string)
            XCTFail()
        } catch EnrichedText.Error.malformed(let position, let reason) {
            XCTAssertEqual(reason, "color param invalid")
            let characters = string[..<position].count
            XCTAssertEqual(characters, 34)
        } catch {
            XCTFail()
        }
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

    func testLowercaseInitPerformance() {
        self.measure {
            for _ in 1...5000 {
                _ = try! EnrichedText(string: Tests.complexExample)
            }
        }
    }

    func testMixedCaseInitPerformance() {
        self.measure {
            for _ in 1...5000 {
                _ = try! EnrichedText(string: Tests.complexMixedCaseExample)
            }
        }
    }

}
