// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit

class ABCViewController: UIViewController {
    lazy var labelA: UILabel = {
        let v = UILabel()
        v.backgroundColor = .blue
        v.text = "A"
        v.textColor = .white
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 100, weight: .bold)
        return v
    }()

    lazy var labelB: UILabel = {
        let v = UILabel()
        v.backgroundColor = .green
        v.text = "B"
        v.textColor = .white
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 100, weight: .bold)
        return v
    }()

    lazy var labelC: UILabel = {
        let v = UILabel()
        v.backgroundColor = .magenta
        v.text = "C"
        v.textColor = .white
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 100, weight: .bold)
        return v
    }()

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
        rootStack.views.forEach { view.addSubview($0) }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        rootStack.layout(in: view.bounds)
    }
}
