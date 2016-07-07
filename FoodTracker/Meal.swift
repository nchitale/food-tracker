//
//  Meal.swift
//  FoodTracker
//
//  Created by Nandini  on 7/6/16.
//
//

import UIKit

class Meal: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage? //the question mark means there may or may not be a photo (it's optional)
    var rating: Int
    
    struct PropertyKey { //"static" means the constant applies to the structure itself, not an instance of the structure
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) { //question mark means the initializer is failable (can return nil)
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
}


