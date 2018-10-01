//
//  ViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 8/21/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var busLoopsSelectButton: UIButton!
    @IBOutlet weak var roomAssignmentsSelectButton: UIButton!
    @IBOutlet weak var scheduleSelectButton: UIButton!
    var headDelPasswordScraped: String
    var headDelPasswordStored: String?
    var headDelEnabled: Bool
    
    func enterHeadDelPassword(enterPassword: String, correctPassword: Bool) {
        if correctPassword {
            headDelPasswordStored = enterPassword
            headDelEnabled = true
            print("perform")
            self.performSegue(withIdentifier: "showHeadDelTableView", sender: self)
            DispatchQueue.main.async {
                self.storePassword()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.headDelEnabled = false
        self.headDelPasswordScraped = ""
        super.init(coder: aDecoder)
        checkHeadDelPassword()
    }
    
    @IBAction func headDelButtonPressed(_ sender: Any) {
        //checkHeadDelPassword()
        print("checked: \(headDelPasswordScraped)")
        if !self.headDelEnabled && headDelPasswordScraped != "" {
            self.performSegue(withIdentifier: "enterPassword", sender: self)
        } else if headDelEnabled {
            self.performSegue(withIdentifier: "showHeadDelTableView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterPassword" {
            let enterPasswordController = segue.destination as! HeadDelPasswordEnterViewController
            enterPasswordController.delegate = self
            print("test1" + headDelPasswordScraped + "test")
            enterPasswordController.correctPassword = headDelPasswordScraped
        } else if segue.identifier == "showHeadDelTableView" {
            print("prepare")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storePassword() {
        if headDelEnabled {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let passwordFileURL = documentDirectoryURL.appendingPathComponent("password").appendingPathExtension("json")
            do {
                let encoder = JSONEncoder()
                let encodeJSON = ["password": headDelPasswordStored]
                let encodedData = try encoder.encode(encodeJSON)
                try encodedData.write(to: passwordFileURL)
            }
            catch {print(error.localizedDescription)}
        }
    }
    
    func checkHeadDelPassword() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let passwordFileURL = documentDirectoryURL.appendingPathComponent("password").appendingPathExtension("json")
        
        do {
            let data = try Data(contentsOf: passwordFileURL)
            let storedPasswordJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            if let oldStoredPassword = storedPasswordJSON!["password"] {
                    headDelPasswordStored = storedPasswordJSON!["password"]
            }
        }
        catch {
            headDelPasswordStored = ""
            print("caught error")
        }
        scrapePassword { password in
            self.headDelPasswordScraped = password
            DispatchQueue.main.async {
                if self.headDelPasswordStored! == "" || self.headDelPasswordStored! != password {
                    self.headDelEnabled = false
                } else {
                    self.headDelEnabled = true
                }
                print("new password: \(password)")
                print("curr password: \(self.headDelPasswordStored!)")
            }
        }
    }
    
    func scrapePassword(completion: @escaping (String) -> Void) {
        let config = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: config)
        let url = URL(string: "https://www.ciaconline.org/assets/appData.json")
        let request = NSMutableURLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        var password = ""
        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(decodedData)
                        password = decodedData["headDelPassword"]! as! String
                        self.headDelPasswordScraped = password
                    }
                    catch { print(error)}
                }
            }
            completion(password)
        }
        task.resume()
    }
}
