// Copyright © 2024 Cocchi is better. All rights reserved.

import Foundation

extension Array {
    var exceptLast: ArraySlice<Element> { 0 < count ? prefix(count - 1) : [] }
}

extension Array where Element == CGRect {
    func lassoRect() -> CGRect {
        let minX = (self.min(by: { $0.minX < $1.minX })?.minX ?? 0)
        let maxX = (self.max(by: { $0.maxX < $1.maxX })?.maxX ?? 0)
        let minY = (self.min(by: { $0.minY < $1.minY })?.minY ?? 0)
        let maxY = (self.max(by: { $0.maxY < $1.maxY })?.maxY ?? 0)
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
