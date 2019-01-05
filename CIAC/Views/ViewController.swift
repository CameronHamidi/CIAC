//
//  ViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 8/21/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, EnterPassword {

    @IBOutlet weak var headDelsSelectButton: UIButton!
    @IBOutlet weak var roomAssignmentsSelectButton: UIButton!
    @IBOutlet weak var scheduleSelectButton: UIButton!
    @IBOutlet weak var staffersSelectButton: UIButton!
    
    var headDelPasswordScraped: String!
    var headDelPasswordStored: String!
    var headDelEnabled: Bool!
    
    var staffPasswordScraped: String!
    var staffPasswordStored: String!
    var staffEnabled: Bool!
    
    var startDate: Date!
    var numConferenceDays: Int!
    
    var committeeTimes: [CommitteeTime]!
    
    func enterPassword(enterPassword: String, correctPassword: Bool, passwordType: PasswordType) {
        if correctPassword {
            switch passwordType {
            case .headDel:
                headDelPasswordStored = enterPassword
                headDelEnabled = true
            case .staff:
                staffPasswordStored = enterPassword
                staffEnabled = true
            }
            DispatchQueue.main.async {
                self.storePassword()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headDelEnabled = false
        self.headDelPasswordScraped = ""
        self.headDelPasswordStored = ""
        
        self.staffPasswordScraped = ""
        self.staffPasswordStored = ""
        self.staffEnabled = false
        
        checkPassword()

        self.headDelsSelectButton.isEnabled = false
        self.staffersSelectButton.isEnabled = false
        self.roomAssignmentsSelectButton.isEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func headDelButtonPressed(_ sender: Any) {
        if !self.headDelEnabled && headDelPasswordScraped != "" {
            self.performSegue(withIdentifier: "enterHeadDelPassword", sender: self)
        } else if headDelEnabled {
            self.performSegue(withIdentifier: "showHeadDelTableView", sender: self)
        }
    }
    
    @IBAction func staffersButtonPressed(_ sender: Any) {
        if !self.staffEnabled && staffPasswordScraped != "" {
            self.performSegue(withIdentifier: "enterStaffPassword", sender: self)
        } else if staffEnabled {
            self.performSegue(withIdentifier: "showStaffView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterHeadDelPassword" || segue.identifier == "enterStaffPassword" {
            let enterPasswordController = segue.destination as! PasswordEnterViewController
            enterPasswordController.viewControllerDelegate = self
            enterPasswordController.committeeTimes = self.committeeTimes
            if segue.identifier == "enterHeadDelPassword" {
                enterPasswordController.passwordType = .headDel
                enterPasswordController.correctPassword = headDelPasswordScraped
            } else if segue.identifier == "enterStaffPassword" {
                enterPasswordController.passwordType = .staff
                enterPasswordController.correctPassword = staffPasswordScraped
            }
        } else if segue.identifier == "showHeadDelTableView" {
//            print("prepare")
        } else if segue.identifier == "enterStaffPassword" {
            let enterPasswordController = segue.destination as! PasswordEnterViewController
            enterPasswordController.viewControllerDelegate = self
            
        } else if segue.identifier == "showBusLoops" {
            let navController = segue.destination as! UINavigationController
            let busController = navController.childViewControllers[0] as! BusTableViewController
            busController.startDate = self.startDate
            busController.numDays = self.numConferenceDays
        } else if segue.identifier == "showSchedule" {
            let navController = segue.destination as! UINavigationController
            let scheduleController = navController.childViewControllers[0] as! ScheduleTableViewController
            scheduleController.startDate = self.startDate
            scheduleController.numDays = self.numConferenceDays
        } else if segue.identifier == "showStaffView" {
            let navController = segue.destination as! UINavigationController
            let staffController = navController.childViewControllers[0] as! StaffRoomsTableViewController
            staffController.committeeTimes = self.committeeTimes
        } else if segue.identifier == "showRooms" {
            let navController = segue.destination as! UINavigationController
            let roomsController = navController.childViewControllers[0] as! RoomsCollectionViewController
            roomsController.committeeTimes = self.committeeTimes
        }
        //super.prepare(for: segue, sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storePassword() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let passwordFileURL = documentDirectoryURL.appendingPathComponent("ciacPassword").appendingPathExtension("json")
        do {
            let encoder = JSONEncoder()
            let encodeJSON = ["headDelPassword": headDelPasswordStored, "staffPassword" : staffPasswordStored]
            let encodedData = try encoder.encode(encodeJSON)
            try encodedData.write(to: passwordFileURL)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func checkPassword() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let passwordFileURL = documentDirectoryURL.appendingPathComponent("ciacPassword").appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: passwordFileURL)
            let storedPasswordJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            if storedPasswordJSON!["headDelPassword"] != nil {
                headDelPasswordStored = storedPasswordJSON!["headDelPassword"]!
            } else {
                headDelPasswordStored = ""
            }
            if storedPasswordJSON!["staffPassword"] != nil {
                staffPasswordStored = storedPasswordJSON!["staffPassword"]!
            } else {
                staffPasswordStored = ""
            }
        }
        catch {
            print("reading password file error")
            print(error.localizedDescription)
            headDelPasswordStored = ""
            staffPasswordStored = ""
        }

        scrapePassword { appDataResponse  in
            if appDataResponse == nil {
                self.headDelEnabled = false
                self.staffEnabled = false
                self.headDelsSelectButton.isEnabled = true
                self.staffersSelectButton.isEnabled = true
            } else {
                self.headDelPasswordScraped = appDataResponse!.headDelPassword
                self.staffPasswordScraped = appDataResponse!.staffPassword
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.dateFormat = "MM-dd-yyyy"
                self.startDate = dateFormatter.date(from: appDataResponse!.conferenceStartDate)
                self.numConferenceDays = appDataResponse!.numConferenceDays
                self.committeeTimes = appDataResponse!.committeeTimes
                DispatchQueue.main.async {
                    self.roomAssignmentsSelectButton.isEnabled = true
                    if self.headDelPasswordStored == "" || self.headDelPasswordStored != self.headDelPasswordScraped {
                        self.headDelEnabled = false
                    } else {
                        self.headDelEnabled = true
                    }
                    self.headDelsSelectButton.isEnabled = true
                    
                    if self.staffPasswordStored == "" || self.staffPasswordStored != self.staffPasswordScraped {
                        self.staffEnabled = false
                    } else {
                        self.staffEnabled = true
                    }
                    self.staffersSelectButton.isEnabled = true
                }
            }
        }
    }
    
    func scrapePassword(completion: @escaping(AppDataResponse?) -> Void) {
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request("https://thecias.github.io/CIAC/appData.json", method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let appDataResponse = try? decoder.decode(AppDataResponse.self, from: data) {
                    completion(appDataResponse)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
//    func scrapePassword(completion: @escaping ((String, String)) -> Void) {
//        let config = URLSessionConfiguration.default
//        let defaultSession = URLSession(configuration: config)
//        let url = URL(string: "https://thecias.github.io/CIAC/appData.json")
//        let request = NSMutableURLRequest(url: url!)
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//        var headDelPassword = ""
//        var staffPassword = ""
//        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
//            do {
//                if let error = error {
//                    print(error.localizedDescription)
//                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                    do {
//                        let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                        if decodedData["headDelPassword"] as! String? != nil {
//                            headDelPassword = decodedData["headDelPassword"]! as! String
//                        }
//                        if decodedData["staffPassword"] as! String? != nil {
//                            staffPassword = decodedData["staffPassword"]! as! String
//                        }
//                    }
//                    catch { print(error)}
//                }
//            }
//            completion((headDelPassword, staffPassword))
//        }
//        task.resume()
//    }
}
