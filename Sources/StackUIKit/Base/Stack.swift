// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit
import LayoutUIKit

@MainActor public class Stack {
    public var direction: Direction
    public var position = CGPoint(x: 0.5, y: 0.5)
    public var spacer = Spacer.fixed(0)
    public var insets = UIEdgeInsets.zero

    public var items = [Item]()

    var targetRect = CGRect()
    var actualRect = CGRect()

    public init(_ direction: Direction) {
        self.direction = direction
    }
}

public extension Stack {
    var frame: CGRect {
        views.map { $0.frame }.lassoRect().inset(by: insets.inverted())
    }

    var views: [UIView] {
        let topLevel = items.compactMap { $0.stackable as? UIView }
        let nested = items.compactMap { ($0.stackable as? Stack)?.views }.flatMap { $0 }
        return topLevel + nested
    }

    var stacks: [Stack] {
        let topLevel = items.compactMap { $0.stackable as? Stack }
        let nested = topLevel.flatMap { $0.stacks }
        return topLevel + nested
    }

    func layout(in rect: CGRect) {
        let calc = FrameCalculator(stack: self, rect: rect.inset(by: insets))
        calc.calculate()
        calc.apply()

        targetRect = rect
        actualRect = calc.lassoRect
    }
}

public extension Stack {
    enum Direction {
        case vertical
        case horizontal
    }

    enum Spacer {
        case fixed(CGFloat)
        case fill(minimum: CGFloat)
    }

    enum Length: Equatable {
        case fit
        case fill
        case fixed(CGFloat)
        case ratio(CGFloat)
    }

    struct Item {
        var stackable: Stackable
        var width: Length
        var height: Length
        var spacer: Spacer?
        var padding: CGSize?
    }
}

extension Stack.Spacer {
    var least: CGFloat {
        switch self {
        case .fixed(let value):  return value
        case .fill(let minimum): return minimum
        }
    }

    var isFill: Bool {
        if case .fill = self {
            return true
        }
        return false
    }
}
