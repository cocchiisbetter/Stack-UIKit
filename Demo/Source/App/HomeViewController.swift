// Copyright © 2024 Cocchi is better. All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    enum Item: String, CaseIterable {
        case abc
        case login
        case nesting

        func viewController() -> UIViewController {
            switch self {
            case .abc:
                return ABCViewController()

            case .login:
                return LoginViewController()

            case .nesting:
                return NestingViewController()
            }
        }

        var title: String { rawValue.uppercased() }
    }

    let items = Item.allCases

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = items[indexPath.row].title

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = item.viewController()
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
