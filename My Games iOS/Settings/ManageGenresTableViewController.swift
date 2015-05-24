//
//  ManageGenresTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/17/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class ManageGenresTableViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var noGenresLabel: UILabel!
    
    var data = Genre.allGenres() as! [Genre]
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "resignOnTap")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapRecognizer)
        
        clearsSelectionOnViewWillAppear = true
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    func resignOnTap() {
        view.endEditing(true)
    }
    
    func reloadData() {
        data = Genre.allGenres() as! [Genre]
        tableView.reloadData()
        
        setNoGenresMessage()
    }
    
    private func setNoGenresMessage() {
        if data.count == 0 {
            noGenresLabel.text = "There are no genres.\nYou can add new genres by tapping the + button."
        } else {
            noGenresLabel.text = String()
        }
    }
    
    // MARK: Actions
    @IBAction func addAction(sender: AnyObject) {
        var alert = UIAlertView(title: "Create New Genre", message: "New genre title:", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Create")
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
        var cell = tableView.dequeueReusableCellWithIdentifier("GenreCell") as! UITableViewCell
        cell.textLabel?.text = data[indexPath.row].title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Genre.remove(data[indexPath.row])
            reloadData()
        }
    }
    
    // MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        var genre = data[indexPath.row]
        
        var alert = UIAlertView(title: "Edit Genre", message: "Genre title:", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.tag = 1001
        
        var textField = alert.textFieldAtIndex(0)
        textField?.text = genre.title
        
        alert.show()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // MARK: Alert view delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var textField = alertView.textFieldAtIndex(0)
        
        if textField!.text.isEmpty {
            return
        }
        
        if alertView.tag == 1000 {
            if buttonIndex != alertView.cancelButtonIndex {
                var newGenre = Genre.createNew(textField!.text)
                
                appDelegate.saveContext()
                reloadData()
            }
        } else {
            if buttonIndex != alertView.cancelButtonIndex {
                var genre = data[selectedIndexPath!.row]
                genre.title = textField!.text
                
                appDelegate.saveContext()
                reloadData()
            }
            
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            selectedIndexPath = nil
        }
    }
    
    func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool {
        let textField = alertView.textFieldAtIndex(0)
        
        if (alertView.tag == 1000) {
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
