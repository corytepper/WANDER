//
//  CurrentWanderVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/21/22.
//

import UIKit
import CoreLocation

class CurrentWanderVC: BaseVC {
    
    // MARK: - UIElements
    private static let titleFontSize: CGFloat = 32
    private static let subtitleFontSize: CGFloat = 24
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WANDERING"
        label.textAlignment = .center
        label.font = label.font.withSize(Self.titleFontSize)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var timelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Self.subtitleFontSize)
        label.text = "00:00:00"
        return label
    }()
    
    
    private lazy var paceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Average Pace"
        label.font = label.font.withSize(Self.subtitleFontSize)
        return label
    }()
    
    private lazy var paceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "0:00"
        label.font = label.font.withSize(Self.titleFontSize)
        return label
    }()
    
    private lazy var paceSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "/mi"
        label.font = label.font.withSize(Self.subtitleFontSize)
        return label
    }()
    
    private lazy var paceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [paceTitleLabel, paceLabel, paceSubtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var distanceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Distance"
        label.font = UIFont.boldSystemFont(ofSize: Self.subtitleFontSize)
        return label
    }()
    
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "0.00"
        label.font = UIFont.boldSystemFont(ofSize: Self.titleFontSize)
        return label
    }()
    
    private lazy var distanceSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "mi"
        label.font = UIFont.boldSystemFont(ofSize: Self.subtitleFontSize)
        return label
    }()
    
    private lazy var distanceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceTitleLabel, distanceLabel, distanceSubtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var pageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timelabel, paceStackView, distanceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return stackView
    }()
    
    private lazy var capsuleView: UIView = {
        let capsule = UIView()
        capsule.translatesAutoresizingMaskIntoConstraints = false
        capsule.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        capsule.layer.cornerRadius = 35
        capsule.layer.masksToBounds = true
        return capsule
    }()
    
    private lazy var stopSliderKnob: UIImageView = {
        let knob = UIImageView()
        knob.translatesAutoresizingMaskIntoConstraints = false
        knob.isUserInteractionEnabled = true
        knob.image = UIImage(systemName: "dot.arrowtriangles.up.right.down.left.circle")
        knob.tintColor = .white
        knob.layer.borderColor = UIColor.white.cgColor
        knob.layer.borderWidth = 5
        knob.layer.cornerRadius = 25
        knob.layer.masksToBounds = true
        return knob
    }()
    
    private lazy var sliderStop: UIImageView = {
        let slider = UIImageView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.image = UIImage(systemName: "stop.circle.fill")
        slider.tintColor = .white
        slider.layer.borderColor = UIColor.clear.withAlphaComponent(0.5).cgColor
        slider.layer.borderWidth = 5
        slider.layer.cornerRadius = 35
        slider.layer.masksToBounds = true
        return slider
    }()
    
    // MARK: - Local variables
    private var startLocation: CLLocation!
    private var endLocation: CLLocation!
    
    private var wanderDistance = 0.0
    private var timeElapsed = 0
    private var pace = 0
    
    private var locationManager = LocationManager()
    
    private var timer = Timer()
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.manager.delegate = self
        startWander()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopWander()
    }
    
    private func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(pageStackView)
        view.addSubview(capsuleView)
        capsuleView.addSubview(stopSliderKnob)
        capsuleView.addSubview(sliderStop)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector((dismissEnd(sender:))))
        stopSliderKnob.addGestureRecognizer(swipeGesture)
    }
    
    private func setupConstraints() {
        //top label
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // page stackview
        NSLayoutConstraint.activate([
            pageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageStackView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8)
        ])
        
        // capsule view
        NSLayoutConstraint.activate([
            capsuleView.widthAnchor.constraint(equalToConstant: 300),
            capsuleView.heightAnchor.constraint(equalToConstant: 70),
            capsuleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            capsuleView.topAnchor.constraint(equalTo: pageStackView.bottomAnchor, constant: 8),
            capsuleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // stop slider knob
        NSLayoutConstraint.activate([
            stopSliderKnob.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 8),
            stopSliderKnob.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            stopSliderKnob.widthAnchor.constraint(equalToConstant: 50),
            stopSliderKnob.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // slider stop image
        NSLayoutConstraint.activate([
            sliderStop.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor),
            sliderStop.centerYAnchor.constraint(equalTo: capsuleView.centerYAnchor),
            sliderStop.widthAnchor.constraint(equalToConstant: 70),
            sliderStop.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    private func startWander() {
        locationManager.manager.startUpdatingLocation()
        startTimer()
        
    }
    
    private func stopWander() {
        locationManager.manager.stopUpdatingLocation()
        stopTimer()
    }
    
    
    private func startTimer() {
        timelabel.text = timeElapsed.formatTimeString()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        timeElapsed = 0
    }
    
    @objc private func updateTimer() {
        timeElapsed += 1
        timelabel.text = timeElapsed.formatTimeString()
    }
    
    private func computePace(time seconds: Int, miles: Double) -> String {
        pace = Int(Double(seconds) / miles)
        return pace.formatTimeString()
        
    }
    
    @objc private func dismissEnd(sender: UIPanGestureRecognizer) {
        let adjust: CGFloat = 35
        let translation = sender.translation(in: view)
        
        if sender.state == .began || sender.state == .changed {
            if stopSliderKnob.center.x > sliderStop.center.x {
                stopSliderKnob.center.x = sliderStop.center.x
                stopWander()
                dismiss(animated: true)
            } else if stopSliderKnob.center.x < capsuleView.bounds.minX + adjust {
                stopSliderKnob.center.x = capsuleView.bounds.minX + adjust
            } else {
                stopSliderKnob.center.x += translation.x
            }
            sender.setTranslation(.zero, in: view)
        } else if sender.state == .ended && stopSliderKnob.center.x < sliderStop.center.x {
            UIView.animate(withDuration: 0.5) {
                self.stopSliderKnob.center.x = self.capsuleView.bounds.minX + adjust
            }
        }
    }
    
}

// MARK: - Extensions
extension CurrentWanderVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            wanderDistance += endLocation.distance(from: location)
            self.distanceLabel.text = self.wanderDistance.meterToMiles().toString(places: 2)
            
            if timeElapsed > 0 && wanderDistance > 0 {
                paceLabel.text = computePace(time: timeElapsed, miles: wanderDistance.meterToMiles())
            }
        }
        endLocation = locations.last
    }
}
