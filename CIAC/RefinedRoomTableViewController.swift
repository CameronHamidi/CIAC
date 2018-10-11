//
//  RefinedRoomTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/10/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class RefinedRoomTableViewController: UITableViewController {

    
    var rooms: [RoomItem]
    var selectedRow: Int?
    var associatedRow: Int
    
    required init?(coder aDecoder: NSCoder) {
        rooms = [RoomItem]()
        associatedRow = 0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("celling refresh")
        refresh(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "committeeCell")
        let committeeLabel = cell?.viewWithTag(1000) as! UILabel
        committeeLabel.text = rooms[indexPath.section].committee
        let roomLabel = cell?.viewWithTag(1001) as! UILabel
        roomLabel.text = rooms[indexPath.section].room
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        scrapeRooms { rooms in
            self.rooms = rooms
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func scrapeRooms(completion: @escaping ([RoomItem]) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/rooms.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var readRooms = [RoomItem]()
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                print("Getting information from website")
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let roomsJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let session = roomsJSON!["session"] as! String
                        print(session)
                        if session == "" {
                            self.showUnavailableRoomsAlert()
                        } else {
                            self.navigationItem.title = session
                            let currSessionJSON = roomsJSON!["rooms"] as! [[String: String]]
                            print(currSessionJSON)
                            for room in currSessionJSON {
                                let newRoomItem = RoomItem(committee: room["committee"]!, room: room["room"]!)
                                readRooms.append(newRoomItem)
                            }
                        }
                    }
                    catch { print(error)}
                }
            }
            completion(readRooms)
        }
        task.resume()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showUnavailableRoomsAlert() {
        let message = "No room assignments available. Check back later."
        let alert = UIAlertController(title: "No room assignments available", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
