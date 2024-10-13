// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit.UIGeometry

@MainActor class FrameCalculator {
    let stack: Stack
    let rect: CGRect
    let estimates: [Estimate]

    init(stack: Stack, rect: CGRect) {
        self.stack = stack
        self.rect = rect
        self.estimates = stack.items.map { Estimate($0) }
    }

    func calculate() {
        calcLeastSpaces()
        calcItemSizes()
        calcActualSpaces()
        calcFrames()
    }

    func apply() {
        estimates.forEach { e in
            e.item.stackable.apply(frame: e.frame)
        }
    }
}

extension FrameCalculator {
    class Estimate {
        var item: Stack.Item
        var space = CGFloat()
        var frame = CGRect()

        init(_ item: Stack.Item) {
            self.item = item
        }
    }
}

extension Stack {
    var hasFill: Bool {
        let targets = items.filter { $0.isVisible }
        let visibleFills = targets.filter { item in
            if let innerStack = item.stackable as? Stack {
                if innerStack.direction == direction {
                    return innerStack.hasFill
                }
            }
            else if item.stackable !== targets.last?.stackable {
                return ((item.spacer ?? spacer)?.isFill ?? false)
            }
            return false
        }
        return !visibleFills.isEmpty
    }
}

extension FrameCalculator {
    var visibleEstimates: [Estimate] {
        estimates.filter { $0.item.isVisible }
    }

    var totalLength: CGFloat {
        switch stack.direction {
        case .horizontal:
            return visibleEstimates.map { $0.frame.width + $0.space }.reduce(0, +)

        case .vertical:
            return visibleEstimates.map { $0.frame.height + $0.space }.reduce(0, +)
        }
    }

    var lassoRect: CGRect {
        visibleEstimates.map { $0.frame }.lassoRect()
    }

    func calcLeastSpaces() {
        visibleEstimates.exceptLast.forEach { e in
            e.space = (e.item.spacer ?? stack.spacer).least
        }
    }

    func calcItemSizes() {
        var total = estimates.map { $0.space }.reduce(0, +)

        // calc with (fixable > flexible) order
        switch stack.direction {
        case .horizontal:
            estimates.filter { $0.item.width != .fill }.forEach { e in
                let fitSize = CGSize(width: rect.width - total, height: rect.height)
                e.frame.size = e.item.size(fitSize: fitSize, stackSize: rect.size)
                total += (e.item.isVisible ? e.frame.width : 0)
            }
            let count = visibleEstimates.filter { $0.item.width == .fill }.count
            estimates.filter { $0.item.width == .fill }.forEach { e in
                let width = (rect.width - total) / CGFloat(0 < count ? count : 1)
                let fitSize = CGSize(width: width, height: rect.height)
                e.frame.size = e.item.size(fitSize: fitSize, stackSize: rect.size)
            }
        case .vertical:
            estimates.filter { $0.item.height != .fill }.forEach { e in
                let fitSize = CGSize(width: rect.width, height: rect.height - total)
                e.frame.size = e.item.size(fitSize: fitSize, stackSize: rect.size)
                total += (e.item.isVisible ? e.frame.height : 0)
            }
            let count = visibleEstimates.filter { $0.item.height == .fill }.count
            estimates.filter { $0.item.height == .fill }.forEach { e in
                let height = (rect.height - total) / CGFloat(0 < count ? count : 1)
                let fitSize = CGSize(width: rect.width, height: height)
                e.frame.size = e.item.size(fitSize: fitSize, stackSize: rect.size)
            }
        }
    }

    func calcActualSpaces() {
        let isHorizontal = (stack.direction == .horizontal)
        let targets = visibleEstimates
        let leastSpaces = targets.exceptLast.map { $0.space }.reduce(0, +)
        let totalSize = targets.map { isHorizontal ? $0.frame.width : $0.frame.height }.reduce(0, +)

        let fillCount = targets.exceptLast.filter { ($0.item.spacer ?? stack.spacer).isFill }.count
        let fillable = (isHorizontal ? rect.width : rect.height) - (totalSize + leastSpaces)
        let fill = (0 < fillCount ? fillable / CGFloat(fillCount) : 0)

        targets.forEach { e in
            if case .fill(let minimum) = e.item.spacer ?? stack.spacer {
                e.space = minimum + fill
            }
        }
    }

    func calcFrames() {
        switch stack.direction {
        case .horizontal:
            let totalWidth = (stack.hasFill ? rect.width : totalLength)
            let remainWidth = rect.width - totalWidth
            var nextX = rect.minX + remainWidth * stack.position.x
            var backstage = nextX

            estimates.forEach { e in
                e.frame.origin.x = (e.item.isVisible ? nextX : backstage)
                e.frame.origin.y = rect.minY + (rect.height - e.frame.height) * stack.position.y
                if e.item.isVisible {
                    nextX = e.frame.maxX + e.space
                    backstage = e.frame.maxX
                }
            }
        case .vertical:
            let totalHeight = (stack.hasFill ? rect.height : totalLength)
            let remainHeight = rect.height - totalHeight
            var nextY = rect.minY + remainHeight * stack.position.y
            var backstage = nextY

            estimates.forEach { e in
                e.frame.origin.x = rect.minX + (rect.width - e.frame.width) * stack.position.x
                e.frame.origin.y = (e.item.isVisible ? nextY : backstage)
                if e.item.isVisible {
                    nextY = e.frame.maxY + e.space
                    backstage = e.frame.maxY
                }
            }
        }
    }
}

extension Stack.Item {
    @MainActor var isVisible: Bool {
        if let view = stackable as? UIView {
            return (0 < view.alpha && !view.isHidden)
        }
        else if let stack = stackable as? Stack {
            return !stack.items.allSatisfy { !$0.isVisible }
        }
        return true
    }

    @MainActor func size(fitSize: CGSize, stackSize: CGSize) -> CGSize {
        let w: CGFloat = {
            switch width {
            case .fit:              return stackable.calculatedSize(fitSize).width
            case .fill:             return fitSize.width
            case .fixed(let value): return value
            case .ratio(let ratio): return stackSize.width * ratio
            }
        }()
        let h: CGFloat = {
            switch height {
            case .fit:              return stackable.calculatedSize(fitSize).height
            case .fill:             return fitSize.height
            case .fixed(let value): return value
            case .ratio(let ratio): return stackSize.height * ratio
            }
        }()
        return CGSize(width: w, height: h).padding(padding).clamped(min: .zero)
    }
}
