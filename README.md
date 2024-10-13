# Stack-UIKit

Stack for UIKit.

# Usage

### Integrate with UIViewController

If you prefer

```swift
class ABCViewController: UIViewController {
    lazy var labelA: UILabel = { /* ... */ }()
    lazy var labelB: UILabel = { /* ... */ }()
    lazy var labelC: UILabel = { /* ... */ }()

    // 1. Describe views & stacks hierarchy.
    lazy var rootStack: Stack = {
        let v = Stack(.vertical)
        v.items = [
            subStack.stackItem(width: .fill, height: .ratio(0.6)),
            labelC.stackItem(width: .fill, height: .fill),
        ]
        return v
    }()

    lazy var subStack: Stack = {
        let v = Stack(.horizontal)
        v.items = [
            labelA.stackItem(width: .fill, height: .fill),
            labelB.stackItem(width: .fixed(200), height: .fill)
        ]
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // 2. Add the views of root stack.
        rootStack.views.forEach { view.addSubview($0) }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // 3. Hook .layout(in: ) to layout views & stacks under the root stack.
        rootStack.layout(in: view.bounds)
    }
}
```

# Installation

Only SwiftPM is supported.
