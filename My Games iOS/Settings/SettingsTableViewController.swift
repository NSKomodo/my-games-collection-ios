//
//  SettingsTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/16/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var manageThumbnailsCell: UITableViewCell!
    @IBOutlet weak var manageThumbnailsLabel: UILabel!
    
    weak var delegate: MasterTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (Thumbnail.allThumbnails()?.count > 0) {
            manageThumbnailsCell.userInteractionEnabled = true
            manageThumbnailsLabel.enabled = true
        } else {
            manageThumbnailsCell.userInteractionEnabled = false
            manageThumbnailsLabel.enabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func doneAction(sender: AnyObject) {
        delegate.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var alert: UIAlertView? = nil
        
        if indexPath.section == 0 && indexPath.row == 0  {
            // About
            performSegueWithIdentifier("aboutSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            // Manage genres
            performSegueWithIdentifier("manageGenresSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            // Manage platforms
            performSegueWithIdentifier("managePlatformsSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            // Manage Thumbnails
            performSegueWithIdentifier("manageThumbnailsSegue", sender: nil)
        } else if indexPath.section == 2 && indexPath.row == 0  {
            // Import JSON content
            alert = UIAlertView(title: "My Games", message: "This action will replace all current data with sample content and cannot be undone. Do you want to import the sample content?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
            alert?.tag = 3
            alert?.show()
            
        } else if indexPath.section == 2 && indexPath.row == 1  {
            // Delete all data
            alert = UIAlertView(title: "My Games", message: "This action will delete all and cannot be undone. Do you want to delete all data?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
            alert?.tag = 4
            alert?.show()
        }
    }
    
    // MARK: Alert view delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView.tag == 3 {
            if (buttonIndex != alertView.cancelButtonIndex) {
                delegate.importJSONData(filename: "data")
                view.setNeedsDisplay()
            }
            
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2), animated: true)
            
            manageThumbnailsCell.userInteractionEnabled = true
            manageThumbnailsLabel.enabled = true
        } else if alertView.tag == 4 {
            if (buttonIndex != alertView.cancelButtonIndex) {
                Game.removeAll()
                Genre.removeAll()
                Platform.removeAll()
                Thumbnail.removeAll()
            }
            
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2), animated: true)
            
            manageThumbnailsCell.userInteractionEnabled = false
            manageThumbnailsLabel.enabled = false
        }
    }
    
}
