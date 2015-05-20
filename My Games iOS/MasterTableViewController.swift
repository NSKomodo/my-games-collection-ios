//
//  MasterTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/14/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit
import CoreData

class MasterTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var totalGamesLabel: UILabel!
    
    var searchController: UISearchController!
    var searchResults = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let searchResultsNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("searchResultsNavigationController") as! UINavigationController
        
        searchController = UISearchController(searchResultsController: searchResultsNavigationController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, 44)
        
        tableView.tableHeaderView = searchController.searchBar
        
        // Hides search bar when view loads
        tableView.setContentOffset(CGPointMake(0, 44), animated: false)
        
        // Setup table view controller
        reloadData()
        
        clearsSelectionOnViewWillAppear = true
        definesPresentationContext = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    private func parseJSON(#filename: String, type: String = "json") -> AnyObject? {
        let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: type)
        let jsonData = NSData(contentsOfFile: filePath!)
        
        return NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
    }
    
    private func setTotalGames() {
        if Game.allGames()!.count == 0 {
            totalGamesLabel.text = "Your game collection is empty.\nYou can add more games by tapping the + button."
        } else {
            totalGamesLabel.text = "Total Games: \(Game.allGames()!.count)"
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        setTotalGames()
    }
    
    func importJSONData(#filename: String, type: String = "json") {
        if let parsedData: AnyObject? = parseJSON(filename: filename, type: type) {
            let data = parsedData != nil ? parsedData as! [String: [[String: String]]] : [String: [[String: String]]]()
            
            if data.count == 0 {
                return
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContext
            let keys = Array(data.keys)
            
            // Extract all games from JSON data
            var allGamesInData = [[String: String]]()
            
            for key in keys {
                allGamesInData += data[key]!
            }
            
            // Create new genres
            Genre.removeAll()
            
            for key in keys {
                let genreEntity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: managedObjectContext!)
                var newGenre = Genre(entity: genreEntity!, insertIntoManagedObjectContext: managedObjectContext)
                
                newGenre.title = key
            }
            
            appDelegate.saveContext()
            
            // Create new platforms
            Platform.removeAll()
            var platformsWithRepetitions = [String]()
            
            for game in allGamesInData {
                platformsWithRepetitions.append(game["platform"]!)
            }
            
            let allPlatformsSet = Set(platformsWithRepetitions)
            
            for platform in allPlatformsSet {
                let platformEntity = NSEntityDescription.entityForName("Platform", inManagedObjectContext: managedObjectContext!)
                var newPlatform = Platform(entity: platformEntity!, insertIntoManagedObjectContext: managedObjectContext)
                
                newPlatform.title = platform
            }
            
            appDelegate.saveContext()
            
            // Create new thumbnails
            Thumbnail.removeAll()
            var thumbnailsWithRepetitions = [String]()
            
            for game in allGamesInData {
                thumbnailsWithRepetitions.append(game["thumbnail"]!)
            }
            
            let allThumbnailsSet = Set(thumbnailsWithRepetitions)
            
            for thumbnail in allThumbnailsSet {
                let thumbnailEntity = NSEntityDescription.entityForName("Thumbnail", inManagedObjectContext: managedObjectContext!)
                var newthumbnail = Thumbnail(entity: thumbnailEntity!, insertIntoManagedObjectContext: managedObjectContext)
                newthumbnail.title = thumbnail
                newthumbnail.data = UIImagePNGRepresentation(UIImage(named: thumbnail))
            }
            
            appDelegate.saveContext()
            
            // Create new games
            Game.removeAll()
            
            for game in allGamesInData {
                var gameEntity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedObjectContext!)
                var newGame = Game(entity: gameEntity!, insertIntoManagedObjectContext: managedObjectContext)
                
                newGame.title = game["title"]!
                newGame.desc = game["description"]!
                newGame.publisher = game["publisher"]!
                newGame.buy = game["buy"]!
                newGame.modes = game["modes"]!
                
                newGame.genre = Genre.genreWithTitle(game["genre"]!)!
                newGame.platform = Platform.platformWithTitle(game["platform"]!)!
                newGame.thumbnail = Thumbnail.thumbnailWithTitle(game["thumbnail"]!)!
            }
            
            appDelegate.saveContext()
        }
    }
    
    // MARK: Actions
    @IBAction func settingsAction(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("settingsNavigationController") as! UINavigationController
        let settingsTableViewController = settingsNavigationController.topViewController! as! SettingsTableViewController
        
        settingsTableViewController.delegate = self
        presentViewController(settingsNavigationController, animated: true) { () -> Void in
            settingsTableViewController.delegate = self
        }
    }
    
    @IBAction func addAction(sender: AnyObject) {
        performSegueWithIdentifier("addSegue", sender: self)
    }
    

    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Genre.allGenres()!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let genre = Genre.allGenres()![section] as! Genre
        
        return Game.allGames(genre: genre)!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("GameCell") as! UITableViewCell
        
        let genre = Genre.allGenres()![indexPath.section] as! Genre
        let game = Game.allGames(genre: genre)![indexPath.row] as! Game
        
        var titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = game.title
        
        var platformLabel = cell.viewWithTag(2) as! UILabel
        platformLabel.text = game.platform.title
        
        var imageView = cell.viewWithTag(3) as! UIImageView
        imageView.image = UIImage(data: game.thumbnail.data)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var allGenres = Genre.allGenres() as! [Genre]
        return allGenres[section].title
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var genre = Genre.allGenres()![indexPath.section] as! Genre
            var game = Game.allGames(genre: genre)![indexPath.row] as! Game
            
            Game.remove(game)
            
            /*if genre.games.count == 0 {
                Genre.remove(genre)
            }*/
            
            reloadData()
        }
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var genre = Genre.allGenres()![indexPath.section] as! Genre
        var game = Game.allGames(genre: genre)![indexPath.row] as! Game
        
        performSegueWithIdentifier("detailSegue", sender: game)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    // MARK: Search results updating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchResults = Game.allGames(title: searchController.searchBar.text) as! [Game]
        
        let searchNavigationController = self.searchController.searchResultsController as! UINavigationController
        let searchResultsTableViewController = searchNavigationController.topViewController as! SearchResultsTableViewController
        
        searchResultsTableViewController.searchResults = searchResults
        searchResultsTableViewController.tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            var detailTableViewController = segue.destinationViewController as! DetailTableViewController
            detailTableViewController.game = sender as! Game
        }
        
        if segue.identifier == "addSegue" {
            var addGameTableViewController = segue.destinationViewController.topViewController as! AddGameTableViewController
            addGameTableViewController.delegate = self
        }
    }
    
}

