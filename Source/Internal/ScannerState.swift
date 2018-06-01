//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

struct ScannerState {
    public enum Error : Swift.Error {
        case missingParam
        case invalidParam
    }

    var style : EnrichedTextStyle {
        return stack.last!.style
    }
    var processNewlines : Bool {
        return !stack.last!.nofill
    }
    private var stack: [ScannerStateItem]

    init() {
        self.stack = [ScannerStateItem(style: EnrichedTextStyle(), nofill: false, command: nil)]
    }

    internal mutating func apply(command:Substring, param:Substring?) throws {
        var item = stack.last!

        item.command = command
        switch (command.lowercased()) {
        case "bold":
            item.style.options.insert(.bold)
        case "italic":
            item.style.options.insert(.italic)
        case "underline":
            item.style.options.insert(.underline)
        case "fixed":
            item.style.options.insert(.fixed)
        case "fontfamily":
            guard let fontFamily = param else {
                throw Error.missingParam
            }
            item.style.fontFamily = String(fontFamily)
        case "color":
            guard let param = param else {
                throw Error.missingParam
            }
            guard let color = EnrichedTextColor(string: String(param)) else {
                throw Error.invalidParam
            }
            item.style.color = color
        case "smaller":
            item.style.relativeFontSize -= 1
        case "bigger":
            item.style.relativeFontSize += 1
        case "nofill":
            item.nofill = true
        default:
            break
        }

        stack.append(item)
    }

    internal mutating func negate(command:Substring) -> Bool {
        let item = stack.popLast()!
        // try exact match first, fallback to case-insensitive; this gives a ~8% improvement in the very common-case
        // that the open and close tags exactly match, at the cost of a ~8% degradation when they don't
        return item.command == command || item.command?.lowercased() == command.lowercased()
    }
}

private struct ScannerStateItem {
    var style : EnrichedTextStyle
    var nofill : Bool
    var command : Substring?
}

