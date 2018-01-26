//
//  RatingControl.swift
//  Food Tracker
//
//  Created by Brett Bertola on 1/25/18.
//  Copyright © 2018 Brett Bertola. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {

    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("ButtonPressed 👍")
    }
    
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        //Ccreate the button
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        // Button constratints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        // Add the button to the stack
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        addArrangedSubview(button)
    }
}
