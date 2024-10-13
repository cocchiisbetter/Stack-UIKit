// Copyright © 2024 Cocchi is better. All rights reserved.

import Foundation

extension CGSize {
    func padding(_ pad: CGSize?) -> CGSize {
        CGSize(
            width: width + (pad?.width ?? 0),
            height: height + (pad?.height ?? 0)
        )
    }

    func clamped(min: CGSize? = nil, max: CGSize? = nil) -> Self {
        var size = self
        size.width = size.width.clamped(min: min?.width, max: max?.width)
        size.height = size.height.clamped(min: min?.height, max: max?.height)
        return size
    }
}
