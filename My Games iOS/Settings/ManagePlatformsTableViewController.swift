//
//  ManagePlatformsTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/17/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class ManagePlatformsTableViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var noPlatformLabel: UILabel!
    
    var data = Platform.allPlatforms() as! [Platform]
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    func reloadData() {
        data = Platform.allPlatforms() as! [Platform]
        tableView.reloadData()
        
        setNoGenresMessage()
    }
    
    private func setNoGenresMessage() {
        if data.count == 0 {
            noPlatformLabel.text = "There are no platforms.\nYou can add new platforms by tapping the + button."
        } else {
            noPlatformLabel.text = String()
        }
    }
    
    // MARK: Actions
    @IBAction func addAction(sender: AnyObject) {
        var alert = UIAlertView(title: "Create New Platform", message: "New platform title:", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Create")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.tag = 1000
        
        alert.show()
    }
    
    // MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PlatformCell") as! UITableViewCell
        cell.textLabel?.text = data[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Platform.remove(data[indexPath.row])
            reloadData()
        }
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        var platform = data[indexPath.row]
        
        var alert = UIAlertView(title: "Edit Platform", message: "Platform title:", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.tag = 1001
        
        var textField = alert.textFieldAtIndex(0)
        textField?.text = platform.title
        
        alert.show()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // MARK: Alert view delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var textField = alertView.textFieldAtIndex(0)
        
        if alertView.tag == 1000 {
            if buttonIndex != alertView.cancelButtonIndex {
                var newPlatform = Platform.createNew(textField!.text)
                
                appDelegate.saveContext()
                reloadData()
            }
        } else {
            if buttonIndex != alertView.cancelButtonIndex {
                var platform = data[selectedIndexPath!.row]
                platform.title = textField!.text
                
                appDelegate.saveContext()
                reloadData()
            }
            
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            selectedIndexPath = nil
        }
    }
    
    func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool {
        let textField = alertView.textFieldAtIndex(0)
        
        if alertView.tag == 1000 {
            if textField!.text.isEmpty {
                return false
            } else {
                return true
            }
        } else {
            if textField!.text.isEmpty {
                return false
            } else if textField!.text == data[selectedIndexPath!.row].title {
                return false
            }
        }
        
        return true
    }
    
}