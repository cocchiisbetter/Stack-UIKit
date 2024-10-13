// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit

public protocol Stackable: AnyObject {
    @MainActor func apply(frame: CGRect)
    @MainActor func calculatedSize(_ fitSize: CGSize) -> CGSize
}

public extension Stackable {
    @MainActor func stackItem(
        width: Stack.Length = .fit,
        height: Stack.Length = .fit,
        spacer: Stack.Spacer? = nil,
        padding: CGSize? = nil
    ) -> Stack.Item {
        .init(stackable: self, width: width, height: height, spacer: spacer, padding: padding)
    }
}

extension Stack: Stackable {
    public func apply(frame: CGRect) {
        layout(in: frame)
    }

    public func calculatedSize(_ fitSize: CGSize) -> CGSize {
        let rect = CGRect(origin: .zero, size: fitSize).inset(by: insets)

        return FrameCalculator(stack: self, rect: rect)
            .calculate()
            .lassoRect
            .inset(by: insets.inverted())
            .size
    }
}

extension UIView: Stackable {
    static var estimateView = UIView()

    public func apply(frame: CGRect) {
        if transform != .identity || !CATransform3DIsIdentity(layer.transform) {
            layout { f in
                f.size = sizeThatFits(.zero)
                f.origin.x = frame.midX - f.width / 2
                f.origin.y = frame.midY - f.height / 2
            }
        }
        else {
            layout { f in
                f = frame
            }
        }
    }

    public func calculatedSize(_ fitSize: CGSize) -> CGSize {
        let fits = sizeThatFits(fitSize)
        let estimateView = Self.estimateView

        if transform != .identity {
            estimateView.transform = transform
            estimateView.bounds.size = fits
            return estimateView.frame.size
        }
        else if !CATransform3DIsIdentity(layer.transform) {
            estimateView.layer.transform = layer.transform
            estimateView.bounds.size = fits
            return estimateView.frame.size
        }
        return fits
    }
}
