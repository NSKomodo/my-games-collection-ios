//
//  AddGameTableViewController.swift
//  My Games iOS
//
//  Created by Jorge Tapia on 5/18/15.
//  Copyright (c) 2015 JORGETAPIA.NET. All rights reserved.
//

import UIKit

class AddGameTableViewController: UITableViewController {

    weak var delegate: MasterTableViewController!
    var firstResponder: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveAction(sender: AnyObject) {
        delegate.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
