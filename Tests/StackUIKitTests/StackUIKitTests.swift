import Testing
import UIKit
import StackUIKit

@MainActor enum Tests {
    @Test static func horizontalFill() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 200)
        let stack = Stack(.horizontal)
        let viewA = UIView()
        let viewB = UIView()

        stack.items = [
            viewA.stackItem(width: .fill, height: .fill),
            viewB.stackItem(width: .fill, height: .fill),
        ]
        stack.layout(in: rect)

        let rowWidth = (rect.width) / CGFloat(stack.items.count)
        #expect(viewA.frame.width == rowWidth)
        #expect(viewA.frame.height == rect.height)
        #expect(viewB.frame.width == rowWidth)
        #expect(viewB.frame.height == rect.height)
    }

    @Test static func verticalFill() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 200)
        let stack = Stack(.vertical)
        let viewA = UIView()
        let viewB = UIView()

        stack.items = [
            viewA.stackItem(width: .fill, height: .fill),
            viewB.stackItem(width: .fill, height: .fill),
        ]
        stack.layout(in: rect)

        let columnHeight = (rect.height) / CGFloat(stack.items.count)
        #expect(viewA.frame.width == rect.width)
        #expect(viewA.frame.height == columnHeight)
        #expect(viewB.frame.width == rect.width)
        #expect(viewB.frame.height == columnHeight)
    }
}
