//
//  HeadDelTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/7/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HeadDelTableViewController: UITableViewController {

    var correctPassword: String?
    var secretariatInfo: [SecretariatInfoResponse]!
    var meetings: [MeetingItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        refresh()
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            dismiss(animated: true, completion: nil)
        }
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
        return 2
    }

    
    @IBAction func close(_ sender: Any) {
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
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "showHeadDelMeetings", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecretariatInfo" {
            let destination = segue.destination as! SecretariatInfoViewController
            destination.secretariatInfo = self.secretariatInfo
        } else if segue.identifier == "showHeadDelMeetings" {
            let destination = segue.destination as! HeadDelMeetingsTableViewController
            destination.meetings = meetings
        }
    }
    
    func refresh() {
        print("configure")
        scrapeInfo { headDelData in
            self.meetings = headDelData!.meetings
            self.secretariatInfo = headDelData!.secretariatInfo
            DispatchQueue.main.async {                
            }
        }
    }
    
    func scrapeInfo(completion: @escaping (HeadDelDataResponse?) -> Void) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request("https://www.ciaconline.org/assets/headDelData.json", method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    print(data)
                    let headDelData = try decoder.decode(HeadDelDataResponse.self, from: data)
                    completion(headDelData)
                } catch {
                    print("here")
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
//    func scrapeInfo(completion: @escaping ((JSON, [MeetingItem])) -> Void) {
//        let config = URLSessionConfiguration.default
//        //config.waitsForConnectivity = true
//        let defaultSession = URLSession(configuration: config)
//        let url = URL(string: "https://www.ciaconline.org/assets/headDelData.json")
//        let request = NSMutableURLRequest(url: url!)
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//        var secretariatInfoJSON = JSON()
//        var scrapedMeetings = [MeetingItem]()
//        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
//            do {
//                print("Getting information from website")
//                if let error = error {
//                    print(error.localizedDescription)
//                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                    do {
//                        let dataJSON = try JSON(data: data)
//                        let secretariatData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        secretariatInfoJSON = dataJSON["secretariatInfo"]
//                        let meetingsArray = try secretariatData!["meetings"] as? [[String: String]]
//                        for meeting in meetingsArray! {
//                            let newDate = meeting["date"]!
//                            let newDescription = meeting["description"]!
//                            let newMeeting = MeetingItem(date: newDate, description: newDescription)
//                            scrapedMeetings.append(newMeeting)
//                        }
//                    }
//                    catch { print(error)}
//                }
//            }
//            completion((secretariatInfoJSON, scrapedMeetings))
//        }
//        task.resume()
//    }

}
