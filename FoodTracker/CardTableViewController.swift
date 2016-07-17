//
//  CardTableViewController.swift
//  FoodTracker
//
//  Created by Nandini  on 7/6/16.
//
//

import UIKit

class CardTableViewController: UITableViewController {
    
    // MARK: Properties
    var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit buton item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem() //special type of bar button with editing behavior built in
        
        // Load any saved cards, otherwise load sample data.
        if let savedCards = loadCards() {
            cards += savedCards
        }
        else {
            // Load the sample data.
            loadSampleCards()
        }
    }
    
    func loadSampleCards() {
        let photo1 = UIImage(named: "card1")!
        let card1 = Card(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "card2")!
        let card2 = Card(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "card3")!
        let card3 = Card(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        cards += [card1, card2, card3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        
        // Fetches the appropriate card for the data source layout.
        let card = cards[indexPath.row]
        
        cell.nameLabel.text = card.name
        cell.photoImageView.image = card.photo
        cell.ratingControl.rating = card.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            cards.removeAtIndex(indexPath.row) //removes Card object to be deleted from cards
            saveCards()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            
            let cardDetailViewController = segue.destinationViewController as! CardViewController
            
            //Get the cell that generated this segue.
            if let selectedCardCell = sender as? CardTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCardCell)!
                let selectedCard = cards[indexPath.row]
                cardDetailViewController.card = selectedCard
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new card.")
        }
    }
    
    @IBAction func unwindToCardList(sender: UIStoryboardSegue) {

        if let sourceViewController = sender.sourceViewController as? CardViewController, card = sourceViewController.card {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing card.
                cards[selectedIndexPath.row] = card
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            
            else {
                // Add a new card.
                let newIndexPath = NSIndexPath(forRow: cards.count, inSection: 0)
                cards.append(card)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the cards.
            saveCards()
            
        }
        
    }
    
    // MARK: NSCoding
    
    func saveCards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cards, toFile: Card.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save cards...")
        }
    }
    
    func loadCards() -> [Card]? { //either returns an array of Card objects or returns nil
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Card.ArchiveURL.path!) as? [Card]
    }

}
