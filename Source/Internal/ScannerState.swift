//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

struct ScannerState {
    var style : EnrichedTextStyle = EnrichedTextStyle(options: [])
    var nofillCount : Int = 0
    var processNewlines : Bool {
        return nofillCount == 0
    }
}

extension ScannerState {
    internal mutating func apply(command:Substring, param:Substring?) {
        switch (command.lowercased()) {
        case "bold":
            style.options.insert(.bold)
        case "italic":
            style.options.insert(.italic)
        case "underline":
            style.options.insert(.underline)
        case "nofill":
            nofillCount += 1
        default:
            break
        }
    }

    internal mutating func negate(command:Substring) {
        switch (command.lowercased()) {
        case "bold":
            style.options.remove(.bold)
        case "italic":
            style.options.remove(.italic)
        case "underline":
            style.options.remove(.underline)
        case "nofill":
            nofillCount -= 1
        default:
            break
        }
    }

}
