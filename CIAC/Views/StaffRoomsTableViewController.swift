//
//  StaffRoomsTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/27/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class StaffRoomsTableViewController: UITableViewController {

    var rooms: [RoomItem]
    var currSession: Int
    var sessionNames: [String]
    var selectedRow: Int
    
    required init?(coder aDecoder: NSCoder) {
        rooms = [RoomItem]()
        currSession = 0
        sessionNames = [String]()
        selectedRow = 0
        super.init(coder: aDecoder)
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            dismiss(animated: true, completion: nil)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "staffRoomCell")
        let room = rooms[indexPath.row]
        let nameLabel = cell?.viewWithTag(1000) as! UILabel
        nameLabel.text = room.committee
        let roomLabel = cell?.viewWithTag(1001) as! UILabel
        roomLabel.text = room.rooms[currSession]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "staffRoomsDetailViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "staffRoomsDetailViewSegue" {
            let roomItem = rooms[selectedRow]
            var scheduleText = ""
            for i in 0..<roomItem.rooms.count {
                scheduleText += sessionNames[i] + ":\n\t" + roomItem.rooms[i] + "\n\n"
            }
            let staffRoomDetailViewController = segue.destination as! StaffRoomDetailViewController
            staffRoomDetailViewController.scheduleText = scheduleText
            staffRoomDetailViewController.navigationItem.title = roomItem.committee
            
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        scrapeStaffRooms { staffTuple in
            self.rooms = staffTuple.0
            self.currSession = staffTuple.1
            DispatchQueue.main.async {
                print(self.rooms.count)
                self.tableView.reloadData()
            }
        }
        scrapeSessionNames { sessionNames in
            self.sessionNames = sessionNames
        }
    }
    
    func scrapeStaffRooms(completion: @escaping (([RoomItem], Int)) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/staff.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var rooms = [RoomItem]()
        var currSession = 0
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let dataJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    currSession = dataJSON!["currSession"] as! Int
                    let staffRoomsJSONArray = dataJSON!["staffRooms"]! as! [[String: Any]]
                    for room in staffRoomsJSONArray {
                        var newRoom = RoomItem(committee: room["name"]! as! String, image: "", rooms: room["rooms"] as! [String])
                        rooms.append(newRoom)
                    }
                }
            }
            catch { print("Scrape schedule error")}
            completion((rooms, currSession))
        }
        task.resume()
        //return schedule
    }
    
    func scrapeSessionNames(completion: @escaping ([String]) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/rooms.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var sessionNames = [String]()
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let dataJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    sessionNames = dataJSON!["sessions"]! as! [String]
                }
            }
            catch { print("Scrape session names error")}
            completion(sessionNames)
        }
        task.resume()
        //return schedule
    }
    
}
