//
//  HeadDelMeetingsTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/30/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class HeadDelMeetingsTableViewController: UITableViewController {

    var meetings: [MeetingItem]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.meetings = []
        super.init(coder: aDecoder)
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
        return meetings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meetingItem = meetings[indexPath.row]
        var cell: UITableViewCell
        if meetingItem.description == "" {
            cell = tableView.dequeueReusableCell(withIdentifier: "meetingCellNoDetail")!
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "meetingCellWithDetail")!
        }
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = meetingItem.date
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
