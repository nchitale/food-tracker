//
//  CardViewController.swift
//  FoodTracker
//
//  Created by Nandini  on 6/26/16.
//
//

import UIKit

class CardViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
        This value is either passed by 'CardTableViewController' in 'prepareForSegue(_:sender:)'
        or constructed as part of adding a new card. 
    */
    
    var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Card.
        if let card = card { //as opposed to card = nil
            navigationItem.title = card.name
            nameTextField.text = card.name
            photoImageView.image = card.photo
            ratingControl.rating = card.rating
        }
        
        // Enable the Save button only if the text field has a valid Card name.
        checkValidCardName()
    }

    /* Not needed for our app
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Hide the Keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidCardName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidCardName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        //Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddCardMode = presentingViewController is UINavigationController //tells you if the pVC is a UINC or not
        
        if isPresentingInAddCardMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        else { //card scene was pushed onto nav stack on top of card list scene
            navigationController!.popViewControllerAnimated(true) //pops current VC (card scene) off the nav stack & animates the transition
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the card to be passed to CardTableViewController after the unwind segue.
            card = Card(name: name, photo: photo, rating: rating)
        }
    }

    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion:  nil)
    }
    
}

