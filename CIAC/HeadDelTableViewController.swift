//
//  HeadDelTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/7/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class HeadDelTableViewController: UITableViewController {

    var correctPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    @IBAction func close(_ sender: Any) {
        print("close")
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadDelCell", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        if indexPath.row == 0 {
            label.text = "Secretariat Information"
        } else if indexPath.row == 1 {
            label.text = "Head Delegate Meetings"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showSecretariatInfo", sender: self)
        } else if indexPath.row == 0 {
            performSegue(withIdentifier: "showHeadDelMeetings", sender: self)
        }
    }

}
