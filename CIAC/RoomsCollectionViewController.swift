//
//  RoomsCollectionViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/12/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RoomsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var rooms: [RoomItem]
    var selectedRoom: Int
    var sessionNumber: Int
    var sessionNames: [String]
    var numSessions: Int
    
    required init?(coder aDecoder: NSCoder) {
        rooms = [RoomItem]()
        selectedRoom = 0
        sessionNumber = 0
        sessionNames = [String]()
        numSessions = 0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return rooms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roomCell", for: indexPath)
    
        let roomItem = rooms[indexPath.row]
        let committeeLabel = cell.viewWithTag(1000) as! UILabel
        committeeLabel.text = roomItem.committee
        let roomLabel = cell.viewWithTag(1001) as! UILabel
        roomLabel.text = rooms[indexPath.row].rooms[sessionNumber]
        let committeeImage = cell.viewWithTag(1004) as! UIImageView
        committeeImage.image = UIImage(named: roomItem.image)
    
        let mainView = cell.viewWithTag(1003) as! UIView
        
        mainView.layer.cornerRadius = 10.0
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.layer.masksToBounds = true
        //mainView.clipsToBounds = true
        
        let shadowView = cell.viewWithTag(1002) as! UIView
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowRadius = 2.0
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.masksToBounds = false
        //shadowView.clipsToBounds = true
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: mainView.layer.cornerRadius).cgPath
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        cell.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            cell.heightAnchor.constraint(equalToConstant: 133)
//            ])
        
//        let width = collectionView.frame.size.width
//        cell.contentView.bounds.size.width = width
//        cell.contentView.setNeedsLayout()
//        cell.contentView.layoutIfNeeded()
//        let height = cell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UILayoutFittingCompressedSize.height)).height
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width, height: 133)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRoom = indexPath.row
        performSegue(withIdentifier: "showCommitteeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCommitteeSegue" {
            let destination = segue.destination as! CommitteeInfoViewController
            destination.committee = rooms[selectedRoom]
            var committeeScheduleText = ""
            for x in 0..<numSessions {
                committeeScheduleText.append(sessionNames[x] + ":\n\t" + rooms[selectedRoom].rooms[x] + "\n\n")
            }
            destination.scheduleText = committeeScheduleText
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        scrapeRooms { scrapedTuple in
            self.rooms = scrapedTuple.0
            self.sessionNumber = scrapedTuple.1
            self.sessionNames = scrapedTuple.2
            self.numSessions = scrapedTuple.3
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func scrapeRooms(completion: @escaping (([RoomItem], Int, [String], Int)) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/rooms.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var readRooms = [RoomItem]()
        var sessionNumber = 0
        var sessionNames = [String]()
        var numSessions = 0
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                print("Getting information from website")
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let roomsJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        sessionNumber = roomsJSON!["session"] as! Int
                        if sessionNumber == 0 {
                            self.showUnavailableRoomsAlert()
                        } else {
                            sessionNames = roomsJSON!["sessions"] as! [String]
                            numSessions = roomsJSON!["numSessions"] as! Int
                            let currSessionJSON = roomsJSON!["rooms"] as! [[String: Any]]
                            for room in currSessionJSON {
                                let newRoomItem = RoomItem(committee: room["committee"]! as! String, image: room["image"]! as! String, rooms: room["rooms"]! as! [String])
                                readRooms.append(newRoomItem)
                            }
                        }
                    }
                    catch { print(error)}
                }
            }
            completion((rooms: readRooms, sessionNumber: sessionNumber - 1, sessionNames, numSessions))
        }
        task.resume()
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
