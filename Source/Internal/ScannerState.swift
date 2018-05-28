//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

struct ScannerState {
    var style : EnrichedTextStyle {
        return stack.last!.style
    }
    var processNewlines : Bool {
        return !stack.last!.nofill
    }
    private var stack: [ScannerStateItem]

    init() {
        self.stack = [ScannerStateItem(style: EnrichedTextStyle(options: []), nofill: false, command: nil)]
    }

    internal mutating func apply(command:Substring, param:Substring?) {
        var item = stack.last!

        item.command = command.lowercased()
        switch (item.command) {
        case "bold":
            item.style.options.insert(.bold)
        case "italic":
            item.style.options.insert(.italic)
        case "underline":
            item.style.options.insert(.underline)
        case "nofill":
            item.nofill = true
        default:
            break
        }

        stack.append(item)
    }

    internal mutating func negate(command:Substring) -> Bool {
        let item = stack.popLast()!
        return item.command == command.lowercased()
    }
}

private struct ScannerStateItem {
    var style : EnrichedTextStyle
    var nofill : Bool
    var command : String?
}

