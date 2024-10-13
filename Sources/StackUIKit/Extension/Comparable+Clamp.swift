// Copyright © 2024 Cocchi is better. All rights reserved.

import Foundation

extension Comparable {
    func clamped(min: Self? = nil, max: Self? = nil) -> Self {
        if let min = min, self < min {
            return min
        }
        else if let max = max, max < self {
            return max
        }
        return self
    }
}
