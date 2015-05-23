//
//  SearchResultsTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/14/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var searchResults = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let game = searchResults[indexPath.row]
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as! UITableViewCell
        cell.imageView?.image = UIImage(data: game.thumbnail.data)
        cell.textLabel?.text = game.title
        cell.detailTextLabel?.text = game.platform.title
        
        return cell
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var game = searchResults[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailTableViewController = storyboard.instantiateViewControllerWithIdentifier("detailTableViewController") as! DetailTableViewController
        
        detailTableViewController.game = game
        presentingViewController!.navigationController?.pushViewController(detailTableViewController, animated: true)
    }

}
