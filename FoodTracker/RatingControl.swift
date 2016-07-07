//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Nandini  on 7/6/16.
//
//

import UIKit

class RatingControl: UIView {
    
    // MARK: Properties
    
    var rating = 0 {
        didSet { // This is a property observer for "rating". ("rating" is the property)
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    let spacing = 5
    let starCount = 5

    // MARK: Initialization
    
    override func layoutSubviews() {
        
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing)) //Note: tutorial says "5" instead of spacing
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false //makes sure image doesn't show additional highlight during state change
            
            //The below line is modified from the tutorial (made for Swift 2.2) to work for Swift 2.1.
            //Refer to http://stackoverflow.com/questions/24007650/selector-in-swift
            //Need the colon after ratingButtonTapped!!!!!
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            
            //This is what you're supposed to do (instead of the above line) in Swift 2.2:
            //button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            
            ratingButtons += [button]
            addSubview(button)
        }
        
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize * starCount) + (spacing * (starCount - 1))
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }
    }

}
