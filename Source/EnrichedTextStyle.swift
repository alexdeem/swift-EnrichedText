//  Copyright © 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

public struct EnrichedTextStyleOptions : OptionSet {
    public let rawValue: Int

    public static let bold = EnrichedTextStyleOptions(rawValue: 1 << 0)
    public static let italic = EnrichedTextStyleOptions(rawValue: 1 << 1)
    public static let underline = EnrichedTextStyleOptions(rawValue: 1 << 2)

    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
}

public struct EnrichedTextStyle {
    public var options: EnrichedTextStyleOptions
}
