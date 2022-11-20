//
//  CircularButton.swift
//  WANDER
//
//  Created by Cory Tepper on 11/20/22.
//

import UIKit

final class CircularButton: UIButton {
    var borderWidth: CGFloat = 10.0
    var borderColor: UIColor = .white
    
    var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    var titleTextColor: UIColor? {
        didSet {
            setTitleColor(titleTextColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        clipsToBounds      = true
        backgroundColor    = UIColor.purple
        layer.cornerRadius = frame.size.width / 2.0
        layer.borderColor  = borderColor.cgColor
        layer.borderWidth  = borderWidth
    }
}
