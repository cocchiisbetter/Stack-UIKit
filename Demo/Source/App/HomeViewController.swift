// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    enum Content: String, CaseIterable {
        case login
        case nesting

        func viewController() -> UIViewController {
            switch self {
            case .login:
                return LoginViewController()

            case .nesting:
                return NestingViewController()
            }
        }

        var title: String { rawValue.capitalized }
    }
    let contents = Content.allCases

    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .plain)
        v.register(Cell.self, forCellReuseIdentifier: Cell.id)
        v.dataSource = self
        v.delegate = self
        v.rowHeight = 60
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tableView.layout { f in
            f = view.bounds
        }
    }
}

extension HomeViewController {
    class Cell: UITableViewCell {
        static let id = "Cell"

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Delegate

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = contents[indexPath.row].title

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = contents[indexPath.row].viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
