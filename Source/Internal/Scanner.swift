//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

private let invertedPlainTextCharacterSet = CharacterSet(charactersIn:"<\n")
private let commandCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
private let invertedCommandCharacterSet = commandCharacterSet.inverted

internal struct Scanner {
    let string : String
    let unicodeScalars : String.UnicodeScalarView
    var currentIndex : String.Index
    var currentStyle : EnrichedTextStyle
    var nofillCount : Int
    var processNewlines : Bool {
        return nofillCount == 0
    }

    public init(string: String) {
        self.string = string
        self.unicodeScalars = string.unicodeScalars
        self.currentIndex = string.startIndex
        self.currentStyle = EnrichedTextStyle(options: [])
        self.nofillCount = 0
    }

    public var isComplete : Bool {
        get {
            return currentIndex >= unicodeScalars.endIndex
        }
    }

    public mutating func scanComponent() throws -> EnrichedTextComponent? {

        while (unicodeScalars[currentIndex] == "<") {
            currentIndex = unicodeScalars.index(after: currentIndex)
            if (unicodeScalars[currentIndex] == "<") {
                // This is an escaped < character; treat it as text
                break;
            }
            try scanAndProcessCommand()
        }

        if currentIndex >= unicodeScalars.endIndex {
            return nil
        }

        if (processNewlines && unicodeScalars[currentIndex] == "\n") {
            currentIndex = unicodeScalars.index(after: currentIndex)
            if (unicodeScalars[currentIndex] != "\n") {
                return EnrichedTextComponent(text: " ", style: currentStyle)
            }
        }

        let text = try scanText()

        return EnrichedTextComponent(text: text, style: currentStyle)
    }

    private mutating func scanAndProcessCommand() throws {
        let negation = (unicodeScalars[currentIndex] == "/")
        if (negation) {
            currentIndex = unicodeScalars.index(after: currentIndex)
        }

        let startIndex = currentIndex
        let endIndex = scanUpTo(characterSet: invertedCommandCharacterSet)
        if (endIndex == unicodeScalars.endIndex) {
            throw EnrichedText.Error.malformed(position: endIndex, reason: "Unterminated Command")
        }
        if (unicodeScalars[endIndex] != ">") {
            throw EnrichedText.Error.malformed(position: endIndex, reason: "Unexpected Character in Command")
        }
        currentIndex = unicodeScalars.index(after: endIndex)

        let command = string[startIndex..<endIndex]
        if (command.caseInsensitiveCompare("nofill") == .orderedSame) {
            if (negation) {
                nofillCount -= 1
            } else {
                nofillCount += 1
            }
            return
        }

        if (negation) {
            currentStyle.negate(command: command)
        } else {
            let param = try scanParam()
            currentStyle.apply(command: command, param: param)
        }
    }

    private mutating func scanParam() throws -> Substring? {
        if (unicodeScalars.suffix(from: currentIndex).starts(with: "<param>".unicodeScalars)) {
            currentIndex = unicodeScalars.index(currentIndex, offsetBy:7)
            let paramStartIndex = currentIndex
            guard let closingParamRange = string.suffix(from: currentIndex).range(of:"</param>") else {
                throw EnrichedText.Error.malformed(position: paramStartIndex, reason: "Expected </param> not found")
            }
            let paramAfterEndIndex = closingParamRange.lowerBound
            currentIndex = closingParamRange.upperBound
            return string[paramStartIndex..<paramAfterEndIndex]
        }
        return nil
    }

    private mutating func scanText() throws -> Substring {
        let startIndex = currentIndex
        if (unicodeScalars[currentIndex] == "\n") {
            // Leading newlines are ok
            repeat {
                currentIndex = unicodeScalars.index(after: currentIndex)
            } while(unicodeScalars[currentIndex] == "\n")
        } else {
            currentIndex = unicodeScalars.index(after: currentIndex) //The first character is guaranteed to be good
        }
        let endIndex = scanUpTo(characterSet: invertedPlainTextCharacterSet)
        currentIndex = endIndex
        return string[startIndex..<endIndex]
    }

    private func scanUpTo(characterSet: CharacterSet) -> String.Index {
        var index = currentIndex
        while index < unicodeScalars.endIndex {
            let scalar = unicodeScalars[index]
            if (characterSet.contains(scalar)) {
                break;
            }
            index = unicodeScalars.index(after:index)
        }
        return index
    }

}
