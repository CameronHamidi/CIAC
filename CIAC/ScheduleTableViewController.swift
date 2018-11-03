//
//  ScheduleTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/1/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit
import Foundation

class ScheduleTableViewController: UITableViewController {

    var schedule: [DayItem]
    var displayDay: Int
    var numDays: Int?
    @IBOutlet weak var prevDayButton: UIBarButtonItem!
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //schedule = scrapeSchedule()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)//action: #selector(addTapped))
        navigationController!.toolbarItems = [add]
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }

    required init?(coder aDecoder: NSCoder) {
        self.displayDay = 0
        self.schedule = [DayItem]()
        self.numDays = 0
        super.init(coder: aDecoder)
        refresh(self)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            if prevDayButton.isEnabled {
                prevDay(self)
            } else {
                dismiss(animated: true, completion: nil)
            }
        } else if sender.direction == .left {
            if nextDayButton.isEnabled {
                nextDay(self)
            }
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        if schedule.count != 0 {
            self.navigationItem.title = self.schedule[self.displayDay].day
        }
    }
    
    func configureDayButtons() {
        if schedule.count == 0 {
            prevDayButton.isEnabled = false
            nextDayButton.isEnabled = false
        } else {
            if displayDay == 0 {
                prevDayButton.isEnabled = false
            } else {
                prevDayButton.isEnabled = true
            }
            
            if displayDay == numDays! - 1 {
                nextDayButton.isEnabled = false
            } else {
                nextDayButton.isEnabled = true
            }
        }
    }
    
    @IBAction func prevDay(_ sender: Any) {
        if displayDay != 0 {
            displayDay -= 1
            configureDayButtons()
            reloadData()
        }
    }
    
    @IBAction func nextDay(_ sender: Any) {
        if displayDay != numDays! - 1 {
            displayDay += 1
            configureDayButtons()
            reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if schedule.count != 0 {
            return schedule[displayDay].events.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayItem = schedule[displayDay]
        let eventItem = dayItem.events[indexPath.row]
        let identifier = eventItem.identifier
        let eventOrTimeText = eventItem.event
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = eventOrTimeText
        if identifier == "event" || identifier == "eventDDI" {
            label.adjustsFontSizeToFitWidth = true
        } else if identifier == "time" {
           label.sizeToFit()
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if schedule[displayDay].events[indexPath.row].information != nil {
            let message = schedule[displayDay].events[indexPath.row].information
            let alert = UIAlertController(title: schedule[displayDay].events[indexPath.row].event, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        scrapeSchedule { schedule in
            self.schedule = schedule
            DispatchQueue.main.async {
                self.reloadData()
                self.numDays = self.schedule.count
                self.configureDayButtons()
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // if schedule.
        if schedule.count != 0 {
            let event = schedule[displayDay].events[indexPath.row]
            if event.identifier == "time" && event.event.count > 51 {
                return 75
            } else if event.identifier == "time" && event.event.count > 31 {
                let additionalChars = event.event.count - 31
                var quotient: Float = Float(additionalChars) / 20.0
                quotient = quotient.rounded(.up)
                return CGFloat(quotient * 14 + 40)
            }
        }
        return 34
    }
    
    func scrapeSchedule(completion: @escaping ([DayItem]) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/schedule.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var schedule = [DayItem]()
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let scheduleArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    for i in 0..<scheduleArray!.count {
                        schedule.append(self.organizeScheduleJSON(scheduleJSON: scheduleArray![i], dayIndex: i))
                    }
                    completion(schedule)
                }
            }
            catch { print("Scrape schedule error")}
        }
        task.resume()
        //return schedule
    }

    func organizeScheduleJSON(scheduleJSON: [String: Any], dayIndex: Int) -> DayItem {
        let returnDayItem = DayItem()
        returnDayItem.day = scheduleJSON["day"] as! String
        let eventTimesArray = scheduleJSON["eventTimes"] as! [[String : Any]]
        for event in eventTimesArray {
            let eventName = event["event"] as! String
            let eventInfo = event["information"] as! String?
            let eventIdentifier = (eventInfo != nil ? "eventDDI" : "event")
            returnDayItem.events.append(EventItem(event: eventName, identifier: eventIdentifier, information: eventInfo))
            let timesArray = event["times"] as! [String]
            for time in timesArray {
                let timeEventItem = EventItem(event: time, identifier: "time")
                returnDayItem.events.append(timeEventItem)
            }
        }
        return returnDayItem
    }
}

func neworganizeScheduleJSON(scheduleJSON: [String: Any], dayIndex: Int) -> DayItem {
    let returnDayItem = DayItem()
    returnDayItem.day = scheduleJSON["day"] as! String
    let eventTimesArray = scheduleJSON["eventTimes"] as! [[String : Any]]
    for event in eventTimesArray {
        let eventName = event["event"] as! String
        returnDayItem.events.append(EventItem(event: eventName, identifier: "event"))
        let timesArray = event["times"] as! [String]
        for time in timesArray {
            let timeEventItem = EventItem(event: time, identifier: "time")
            returnDayItem.events.append(timeEventItem)
        }
    }
    return returnDayItem
}
