//
//  RatingControl.swift
//  Food Tracker
//
//  Created by Brett Bertola on 1/25/18.
//  Copyright © 2018 Brett Bertola. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {

    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
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
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), doesn't exist sorry")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            //if the selected star is the rating then rest rating
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    //MARK: Private Methods
    
    
    // Set up the buttons
    
    private func setupButtons() {
        
        //Clear all the current buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        // Clear out the button array
        ratingButtons.removeAll()
        
        for index in 0..<starCount {
            
            
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            // Set the accessability label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Set the button images
            button.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "filledStar"), for: .selected)
            button.setImage(#imageLiteral(resourceName: "highlightedStar"), for: .highlighted)
            button.setImage(#imageLiteral(resourceName: "highlightedStar"), for: [.highlighted, .selected])
            
            
            // Button constratints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            
           // If the button selected is less then the rating then that button should be selected
            button.isSelected = index < rating
            
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 Star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
            
        }
        
    }

}
