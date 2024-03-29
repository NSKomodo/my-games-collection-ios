//
//  DetailTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/16/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = game.title
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func editAction(sender: AnyObject) {
        performSegueWithIdentifier("editSegue", sender: self)
    }
    
    // MARK: Methods
    func reloadData() {
        tableView.reloadData()
    }
    
    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = !game.modes.isEmpty ? game.modes : "N/A"
            
            cell.imageView?.image = game.thumbnail.title.isEmpty ? UIImage(named: "default_image") : UIImage(data: game.thumbnail.data)
        } else if indexPath.section == 1 {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Publisher"
                cell.detailTextLabel?.text = !game.publisher.isEmpty ? game.publisher : "N/A"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Genre"
                cell.detailTextLabel?.text = game.genre.title
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Platform"
                cell.detailTextLabel?.text = game.platform.title
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Buy Link"
                cell.detailTextLabel?.text = !game.buy.isEmpty ? game.buy : "N/A"
            }
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = !game.desc.isEmpty ? game.desc : "No description available"
        }
        
        return cell
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: game.buy)!)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 88
        } else if indexPath.section == 3 {
            if game.desc.isEmpty {
                return 44
            } else {
                let textAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(16)]
                let textSize = game.desc.boundingRectWithSize(CGSizeMake(view.frame.size.width - 30, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
                
                return textSize.height + 44
            }
        } else {
            return 44
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            var editGameTableViewController = segue.destinationViewController.topViewController as! EditGameTableViewController
            editGameTableViewController.delegate = self
        }
    }
}
