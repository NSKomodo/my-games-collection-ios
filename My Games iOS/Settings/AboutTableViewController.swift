//
//  AboutTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/16/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://github.com/georgetapia")!)
            } else if indexPath.row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/itsProf")!)
            } else if indexPath.row == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://jorgetapia.net")!)
            } else if indexPath.row == 3 {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/artist/jorge-tapia/id562577345")!)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/danigarciam")!)
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://gamestop.com")!)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
