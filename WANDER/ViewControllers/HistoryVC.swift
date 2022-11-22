//
//  HistoryVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/20/22.
//

import UIKit

class HistoryVC: BaseVC {
    
    private static let reuseId = "REUSEID"

    
    // MARK: - UI Elements
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PAST WANDERS"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = label.font.withSize(32)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.register(HistoryTableViewCell.self, forCellReuseIdentifier: Self.reuseId)
        table.backgroundColor = .clear
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorColor = .white
        return table
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        // top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //table view
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - Extension
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseId) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.totalMiles = Double(indexPath.row)
        cell.totalTime = "0:23:12"
        cell.entryDate = "11/11/2011"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
