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
    
    var headDelPasswordScraped: String
    var headDelPasswordStored: String
    var headDelEnabled: Bool
    
    var staffPasswordScraped: String
    var staffPasswordStored: String
    var staffEnabled: Bool

    
    func enterPassword(enterPassword: String, correctPassword: Bool, passwordType: String) {
        if correctPassword {
            if passwordType == "Head Delegate" {
                headDelPasswordStored = enterPassword
                headDelEnabled = true
                print("perform")
                self.performSegue(withIdentifier: "showHeadDelTableView", sender: self)
            } else if passwordType == "staff" {
                staffPasswordStored = enterPassword
                staffEnabled = true
                self.performSegue(withIdentifier: "showStaffView", sender: self)
            }
            DispatchQueue.main.async {
                self.storePassword()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.headDelEnabled = false
        self.headDelPasswordScraped = ""
        self.headDelPasswordStored = ""
        
        self.staffPasswordScraped = ""
        self.staffPasswordStored = ""
        self.staffEnabled = false
        
        super.init(coder: aDecoder)
        checkPassword()
    }
    
    @IBAction func headDelButtonPressed(_ sender: Any) {
        //checkHeadDelPassword()
        print("checked: \(headDelPasswordScraped)")
        if !self.headDelEnabled && headDelPasswordScraped != "" {
            self.performSegue(withIdentifier: "enterHeadDelPassword", sender: self)
        } else if headDelEnabled {
            self.performSegue(withIdentifier: "showHeadDelTableView", sender: self)
        }
    }
    
    @IBAction func staffersButtonPressed(_ sender: Any) {
        print("staff button pressed")
        print(staffPasswordScraped)
        if !self.staffEnabled && staffPasswordScraped != "" {
            self.performSegue(withIdentifier: "enterStaffPassword", sender: self)
        } else if staffEnabled {
            self.performSegue(withIdentifier: "showStaffView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterHeadDelPassword" {
            let enterPasswordController = segue.destination as! PasswordEnterViewController
            enterPasswordController.viewControllerDelegate = self
            enterPasswordController.passwordType = "Head Delegate"
            enterPasswordController.correctPassword = headDelPasswordScraped
        } else if segue.identifier == "showHeadDelTableView" {
            print("prepare")
        } else if segue.identifier == "enterStaffPassword" {
            let enterPasswordController = segue.destination as! PasswordEnterViewController
            enterPasswordController.viewControllerDelegate = self
            enterPasswordController.passwordType = "staff"
            enterPasswordController.correctPassword = staffPasswordScraped
        } else if segue.identifier == "showStaffView" {
            
        }
        //super.prepare(for: segue, sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headDelsSelectButton.isEnabled = false
        self.staffersSelectButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storePassword() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let passwordFileURL = documentDirectoryURL.appendingPathComponent("password").appendingPathExtension("json")
        do {
            let encoder = JSONEncoder()
            print("staff: \(staffPasswordStored)")
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
        let passwordFileURL = documentDirectoryURL.appendingPathComponent("password").appendingPathExtension("json")
        
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
            headDelPasswordStored = ""
            staffPasswordStored = ""
        }

        scrapePassword { passwordTuple  in
            self.headDelPasswordScraped = passwordTuple.0
            self.staffPasswordScraped = passwordTuple.1
            DispatchQueue.main.async {
                if self.headDelPasswordStored == "" || self.headDelPasswordStored != passwordTuple.0 {
                    self.headDelEnabled = false
                } else {
                    self.headDelEnabled = true
                }
                self.headDelsSelectButton.isEnabled = true
                
                if self.staffPasswordStored == "" || self.staffPasswordStored != passwordTuple.1 {
                    self.staffEnabled = false
                } else {
                    self.staffEnabled = true
                }
                self.staffersSelectButton.isEnabled = true
            }
        }
    }
    
    func scrapePassword(completion: @escaping ((String, String)) -> Void) {
        let config = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/appData.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var headDelPassword = ""
        var staffPassword = ""
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(decodedData)
                        if decodedData["headDelPassword"] as! String? != nil {
                            headDelPassword = decodedData["headDelPassword"]! as! String
                        }
                        if decodedData["staffPassword"] as! String? != nil {
                            staffPassword = decodedData["staffPassword"]! as! String
                        }
                    }
                    catch { print(error)}
                }
            }
            completion((headDelPassword, staffPassword))
        }
        task.resume()
    }
}
