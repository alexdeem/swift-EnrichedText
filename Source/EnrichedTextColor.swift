//  Copyright (c) 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

public struct EnrichedTextColor: Equatable {
    public let red: UInt16
    public let green: UInt16
    public let blue: UInt16
    public let alpha: UInt16

    public init(red: UInt16, green: UInt16, blue: UInt16, alpha: UInt16) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    private init?(colorName: String) {
        switch colorName {
        case "red":
            self.init(red: UInt16.max, green: 0, blue: 0, alpha: UInt16.max)
            return
        case "blue":
            self.init(red: 0, green: 0, blue: UInt16.max, alpha: UInt16.max)
            return
        case "green":
            self.init(red: 0, green: UInt16.max, blue: 0, alpha: UInt16.max)
            return
        case "yellow":
            self.init(red: UInt16.max, green: UInt16.max, blue: 0, alpha: UInt16.max)
            return
        case "cyan":
            self.init(red: 0, green: UInt16.max, blue: UInt16.max, alpha: UInt16.max)
            return
        case "magenta":
            self.init(red: UInt16.max, green: 0, blue: UInt16.max, alpha: UInt16.max)
            return
        case "black":
            self.init(red: 0, green: 0, blue: 0, alpha: UInt16.max)
            return
        case "white":
            self.init(red: UInt16.max, green: UInt16.max, blue: UInt16.max, alpha: UInt16.max)
            return
        default:
            return nil
        }
    }

    private init?(stringComponents components: [String]) {
        if components.count < 3 {
            return nil
        }

        guard let red = UInt16(components[0], radix: 16),
            let green = UInt16(components[1], radix: 16),
            let blue = UInt16(components[2], radix: 16),
            let alpha = components.count > 3 ? UInt16(components[3], radix: 16) : UInt16.max else {
                return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public init?(string: String) {
        let components = string.components(separatedBy: ",")
        if components.count == 1 {
            self.init(colorName: string)
        } else {
            self.init(stringComponents: components)
        }
    }
}
