//  Copyright (c) 2018 Tabcorp Pty. Ltd. All rights reserved.

import Foundation

public struct EnrichedText {
    public enum Error : Swift.Error {
        case malformed(position: String.Index, reason: String)
    }

    private let string: String
    public let components: [EnrichedTextComponent]

    public init(string: String) throws {
        var components : [EnrichedTextComponent] = []
        var scanner = Scanner(string: string)
        while !scanner.isComplete {
            if let component = try scanner.scanComponent() {
                components.append(component)
            }
        }
        self.string = string
        self.components = components
    }

    public var plainText: String {
        return components.map{ $0.text }.joined()
    }

}

extension EnrichedText : CustomStringConvertible {
    public var description: String {
        return string
    }
}

extension EnrichedText : ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        try! self.init(string:"\(value)")
    }
}

extension EnrichedText : Equatable {
    public static func == (lhs: EnrichedText, rhs: EnrichedText) -> Bool {
        return lhs.string == rhs.string
    }
}

extension EnrichedText : Hashable {
    public var hashValue: Int {
        return string.hashValue
    }
}

extension EnrichedText : Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string:string)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
