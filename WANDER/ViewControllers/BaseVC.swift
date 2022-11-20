//
//  BaseVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/19/22.
//

import UIKit

class BaseVC: UIViewController {

    private lazy var backgroundLayer: GradientView = {
        let gradient = GradientView(colors: [
            .red,
            .purple,
            .cyan
        ])
        
        gradient.translatesAutoresizingMaskIntoConstraints = false
        
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewConstraints()
    }
    
    private func setupViews() {
        view.addSubview(backgroundLayer)
    }
    
    private func setupViewConstraints() {
        //background layer
        NSLayoutConstraint.activate([
            backgroundLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLayer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
