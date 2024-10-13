// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit.UIGeometry

extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
