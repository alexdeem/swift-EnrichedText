//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

private let commandOpenCharacterSet = CharacterSet(charactersIn:"<")
private let invertedPlainTextCharacterSet = CharacterSet(charactersIn:"<\n")
private let commandCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
private let invertedCommandCharacterSet = commandCharacterSet.inverted

internal struct Scanner {
    let string : String
    let unicodeScalars : String.UnicodeScalarView
    var currentIndex : String.Index
    var state : ScannerState

    public init(string: String) {
        self.string = string
        self.unicodeScalars = string.unicodeScalars
        self.currentIndex = string.startIndex
        self.state = ScannerState()
    }

    public var isComplete : Bool {
        get {
            return currentIndex >= unicodeScalars.endIndex
        }
    }

    public mutating func scanComponent() throws -> EnrichedTextComponent? {
        while let (command, negation) = try scanCommand() {
            try processCommand(command, negation: negation)
        }

        if currentIndex >= unicodeScalars.endIndex {
            return nil
        }

        if (state.processNewlines && unicodeScalars[currentIndex] == "\n") {
            currentIndex = unicodeScalars.index(after: currentIndex)
            if (unicodeScalars[currentIndex] != "\n") {
                return EnrichedTextComponent(text: " ", style: state.style)
            }
        }

        let text = try scanText()

        return EnrichedTextComponent(text: text, style: state.style)
    }

    private mutating func scanCommand() throws -> (command: Substring, negation: Bool)? {
        guard !isComplete else {
            return nil
        }
        
        if (unicodeScalars[currentIndex] != "<") {
            return nil;
        }
        currentIndex = unicodeScalars.index(after: currentIndex)
        if (unicodeScalars[currentIndex] == "<") {
            // This is an escaped < character; treat it as text
            return nil;
        }

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
        return (command, negation)
    }

    private mutating func processCommand(_ command: Substring, negation: Bool) throws {
        if (negation) {
            if (!state.negate(command: command)) {
                throw EnrichedText.Error.malformed(position: currentIndex, reason: "Unbalanced Command Tag")
            }
        } else {
            var param : Substring? = nil
            var processNextCommand : Bool = true
            let nextCommandObj = try scanCommand()
            if let (nextCommand, nextCommandNegation) = nextCommandObj {
                if (nextCommand.lowercased() == "param" && nextCommandNegation == false) {
                    param = try scanParam()
                    processNextCommand = false
                }
            }

            do {
                try state.apply(command: command, param: param)
            } catch ScannerState.Error.missingParam {
                throw EnrichedText.Error.malformed(position: currentIndex, reason: "\(command) command requires param")
            } catch ScannerState.Error.invalidParam {
                throw EnrichedText.Error.malformed(position: currentIndex, reason: "\(command) param invalid")
            }

            if (processNextCommand) {
                if let (nextCommand, nextCommandNegation) = nextCommandObj {
                    try processCommand(nextCommand, negation: nextCommandNegation)
                }
            }
        }
    }

    private mutating func scanParam() throws -> Substring {
        let startIndex = currentIndex
        var endIndex = currentIndex
        while (currentIndex < unicodeScalars.endIndex) {
            currentIndex = scanUpTo(characterSet: commandOpenCharacterSet)
            endIndex = currentIndex
            if let (command, negation) = try scanCommand() {
                if (command.lowercased() == "param" && negation == true) {
                    return string[startIndex..<endIndex]
                }
            } else {
                if currentIndex < unicodeScalars.endIndex {
                    currentIndex = unicodeScalars.index(after: currentIndex)
                }
            }
        }
        throw EnrichedText.Error.malformed(position: startIndex, reason: "Expected </param> not found")
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
