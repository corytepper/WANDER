//
//  HistoryTableViewCell.swift
//  WANDER
//
//  Created by Cory Tepper on 11/21/22.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    // MARK: - external props
    var totalMiles: Double = 0.0 {
        didSet {
            totalMilesLabel.text = String(format: "%0.1f", totalMiles)
            layoutIfNeeded()
        }
    }
    
    var totalTime: String = "00:11:11" {
        didSet {
            totalTimeLabel.text = totalTime
            layoutIfNeeded()
        }
    }
    
    var entryDate: String = "04/01/2021" {
        didSet {
            entryDateLabel.text = entryDate
            layoutIfNeeded()
        }
    }
    
    // MARK: - UI Elements
    private lazy var totalMilesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.0"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
 
    private lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.0"
        label.textColor = .white
        label.font = label.font.withSize(18)
        return label
    }()
    
    private lazy var entryDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.0"
        label.textColor = .white
        label.font = label.font.withSize(18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        contentView.addSubview(totalMilesLabel)
        contentView.addSubview(totalTimeLabel)
        contentView.addSubview(entryDateLabel)
    }
    
    
    private func setupConstraints() {
        // total miles layout
        NSLayoutConstraint.activate([
            totalMilesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalMilesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        // total time label
        NSLayoutConstraint.activate([
            totalTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalTimeLabel.topAnchor.constraint(equalTo: totalMilesLabel.bottomAnchor, constant: 8),
            totalTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // entry date label
        NSLayoutConstraint.activate([
            entryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            entryDateLabel.centerYAnchor.constraint(equalTo: totalMilesLabel.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    
}
