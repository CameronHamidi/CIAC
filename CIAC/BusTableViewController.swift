//
//  BusTableViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class BusTableViewController: UITableViewController {

    var busDays: [BusDayItem]
    var numDays: Int
    var displayDay: Int
    var addresses: [[String: String]]
    @IBOutlet weak var prevDayButton: UIBarButtonItem!
    @IBOutlet weak var nextDayButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        busDays = [BusDayItem]()
        numDays = 0
        displayDay = 0
        addresses = [[String: String]]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddressesSegue" {
            let destination = segue.destination as! AddressViewController
            destination.addressArray = self.addresses
            print(self.addresses)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }

    func reloadData() {
        tableView.reloadData()
        if busDays.count != 0 {
            self.navigationItem.title = self.busDays[self.displayDay].day
        }
    }
    
    func configureDayButtons() {
        if busDays.count == 0 {
            prevDayButton.isEnabled = false
            nextDayButton.isEnabled = false
        } else {
            if displayDay == 0 {
                prevDayButton.isEnabled = false
            } else {
                prevDayButton.isEnabled = true
            }
            
            if displayDay == numDays - 1 {
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
        if displayDay != numDays - 1 {
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
        if busDays.count != 0 {
            return busDays[displayDay].busItems.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let busDay = busDays[displayDay]
        let busItem = busDay.busItems[indexPath.row]
        let name = busItem.name
        let time = busItem.time
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "busCell", for: indexPath)
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        nameLabel.text = name
        nameLabel.adjustsFontSizeToFitWidth = true
        
        let timeLabel = cell.viewWithTag(1001) as! UILabel
        timeLabel.text = time
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        scrapeBuses { busTuple in
            self.busDays = busTuple.0
            self.addresses = busTuple.1
            DispatchQueue.main.async {
                self.reloadData()
                self.numDays = self.busDays.count
                self.configureDayButtons()
                print(self.addresses)
            }
        }
    }
    
    func scrapeBuses(completion: @escaping (([BusDayItem], [[String: String]])) -> Void) {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/buses.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var busDays = [BusDayItem]()
        var addresses = [[String: String]]()
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let busJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    addresses = busJSON?["addresses"] as! [[String: String]]
                    let busDaysArrayJSON = busJSON?["buses"] as! [[String: Any]]?
                    for busDay in busDaysArrayJSON! {
                        var newBusDay = BusDayItem(day: busDay["day"] as! String, busItems: [])
                        for busItem in busDay["buses"] as! [[String: String]] {
                            var newBusItem = BusItem(name: busItem["bus"]!, time: busItem["time"]!)
                            newBusDay.busItems.append(newBusItem)
                        }
                        busDays.append(newBusDay)
                    }
                    completion((busDays, addresses))
                }
            }
            catch { print("Scrape buses error")}
        }
        task.resume()
    }

}
