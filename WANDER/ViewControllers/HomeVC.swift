//
//  HomeVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/20/22.
//

import UIKit
import MapKit

class HomeVC: BaseVC {
    
    //MARK: - UIElements
    private lazy var startButton: CircularButton = {
        let button = CircularButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.borderWidth = 10
        button.borderColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        button.titleText = "GO"
        button.addTarget(self, action: #selector(startWander), for: .touchUpInside)
        return button
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WANDER"
        label.textAlignment = .center
        label.textColor = .white
        label.font = label.font.withSize(32)
        return label
    }()
    
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.alpha = 0.8
        map.delegate = self
        return map
    }()
    
    //MARK: - Local variables
    private var locationManager = LocationManager()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    
    
    
    //MARK: - Helpers
    @objc private func startWander() {
        let currentWanderVC = CurrentWanderVC()
        currentWanderVC.modalPresentationStyle = .fullScreen
        present(currentWanderVC, animated: true)
    }
    
    private func setupViews() {
        locationManager.checkLocationAuthorization()
        view.addSubview(topLabel)
        view.addSubview(mapView)
        view.addSubview(startButton)
    }
    
    private func setupConstraints() {
        // top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // map view
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // start button
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 100),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}


//MARK: - Extension
extension HomeVC: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
}
