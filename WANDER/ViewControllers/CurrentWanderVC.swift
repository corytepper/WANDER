//
//  CurrentWanderVC.swift
//  WANDER
//
//  Created by Cory Tepper on 11/21/22.
//

import UIKit
import CoreLocation
import RealmSwift
import ShimmerSwift

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
        label.textColor = .white
        return label
    }()
    
    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Time spent outside exploring your beautiful world"
        label.font = UIFont.boldSystemFont(ofSize: Self.subtitleFontSize)
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
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeTitleLabel, timelabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
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
        let stackView = UIStackView(arrangedSubviews: [timeStackView, distanceStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return stackView
    }()
    
    private lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        sliderView.layer.cornerRadius = 35
        sliderView.layer.masksToBounds = true
        return sliderView
    }()
    
    private lazy var stopSliderKnob: UIImageView = {
        let knob = UIImageView()
        knob.translatesAutoresizingMaskIntoConstraints = false
        knob.isUserInteractionEnabled = true
        knob.image = UIImage(systemName: "arrow.right.circle")
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
    
    private lazy var sliderText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Slide to Stop"
        label.textColor = .white
        label.font = label.font.withSize(Self.subtitleFontSize)
        return label
    }()
    
    private lazy var sliderShimmer: ShimmeringView = {
        let slider = ShimmeringView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.shimmerSpeed = 1
        slider.shimmerPauseDuration = 2
        return slider
    }()
    
    // MARK: - Local variables
    private var startLocation: CLLocation!
    private var endLocation: CLLocation!
    
    private var wanderDistance = 0.0
    private var timeElapsed = 0
    private var pace = 0
    fileprivate var coordLocations = List<Location>()
    
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
        sliderBounceAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopWander()
    }
    
    private func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(pageStackView)
        view.addSubview(sliderView)
        sliderView.addSubview(stopSliderKnob)
        sliderView.addSubview(sliderStop)
        
        sliderView.addSubview(sliderText)
        sliderView.addSubview(sliderShimmer)
        
        sliderShimmer.contentView = sliderText
        sliderShimmer.isShimmering = true
        
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
            sliderView.widthAnchor.constraint(equalToConstant: 300),
            sliderView.heightAnchor.constraint(equalToConstant: 70),
            sliderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sliderView.topAnchor.constraint(equalTo: pageStackView.bottomAnchor, constant: 8),
            sliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // stop slider knob
        NSLayoutConstraint.activate([
            stopSliderKnob.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 8),
            stopSliderKnob.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            stopSliderKnob.widthAnchor.constraint(equalToConstant: 50),
            stopSliderKnob.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // slider stop image
        NSLayoutConstraint.activate([
            sliderStop.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor),
            sliderStop.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            sliderStop.widthAnchor.constraint(equalToConstant: 70),
            sliderStop.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // slider text
        NSLayoutConstraint.activate([
            sliderText.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            sliderText.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor)
        ])
        
        // shimmer
        NSLayoutConstraint.activate([
            sliderShimmer.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 75),
            sliderShimmer.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -75),
            sliderShimmer.topAnchor.constraint(equalTo: sliderView.topAnchor),
            sliderShimmer.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor)
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
    
    
    @objc private func dismissEnd(sender: UIPanGestureRecognizer) {
        let adjust: CGFloat = 35
        let translation = sender.translation(in: view)
        
        if sender.state == .began || sender.state == .changed {
            if stopSliderKnob.center.x > sliderStop.center.x {
                stopSliderKnob.center.x = sliderStop.center.x
                stopWander()
                
                Wander.addWanderToRealm(pace: pace, distance: wanderDistance, duration: timeElapsed, locations: coordLocations)
                
                dismiss(animated: true)
            } else if stopSliderKnob.center.x < sliderView.bounds.minX + adjust {
                stopSliderKnob.center.x = sliderView.bounds.minX + adjust
            } else {
                stopSliderKnob.center.x += translation.x
            }
            sender.setTranslation(.zero, in: view)
        } else if sender.state == .ended && stopSliderKnob.center.x < sliderStop.center.x {
            UIView.animate(withDuration: 0.5) {
                self.stopSliderKnob.center.x = self.sliderView.bounds.minX + adjust
            }
        }
    }
    
    
    private func sliderBounceAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.stopSliderKnob.center.x += 100
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
                self.stopSliderKnob.center.x -= 100
            } completion: { _ in }
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
            
            let newLocation = Location(lat: endLocation.coordinate.latitude, long: endLocation.coordinate.longitude)
            coordLocations.insert(newLocation, at: 0)
            
            self.distanceLabel.text = self.wanderDistance.meterToMiles().toString(places: 2)
            
        }
        endLocation = locations.last
    }
}
