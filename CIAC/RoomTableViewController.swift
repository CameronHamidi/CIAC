//
//  RoomTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 8/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class RoomTableViewController: UITableViewController {

    var rooms: [String]
    
    required init?(coder aDecoder: NSCoder) {
        rooms = [String]()
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let room = rooms[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = room
        label.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            showTappedRoomAlert(room: rooms[indexPath.row])
        }
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
    
    func scrapeRooms(completion: @escaping ([String]) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/rooms.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var readRooms = [String]()
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
                            self.navigationController?.title = session
                            readRooms = roomsJSON!["rooms"] as! [String]
                        }                    }
                    catch { print(error)}
                }
            }
            completion(readRooms)
            //completionHandler(loops)
        }
        task.resume()
    }
    
    func scrapeRooms() -> [String] {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/appData.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var readRooms = [String]()
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                print("Getting information from website")
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data,
                    let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        //do {
                        //let jsonDecoder = JSONDecoder()
                        let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let roomsJSON = decodedData!["roomAssignments"] as! [String: Any]
                        let session = roomsJSON["session"] as! String
                    print(session)
                        if session == "" {
                            self.showUnavailableRoomsAlert()
                        } else {
                            self.navigationController?.title = session
                            readRooms = roomsJSON["rooms"] as! [String]
                        }
                    }
            }
            catch { print(error)}
        }
        task.resume()
        return readRooms
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
    
    func showTappedRoomAlert(room: String) {
        let message = room
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
