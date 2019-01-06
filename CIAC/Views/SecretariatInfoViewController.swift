//
//  SecretariatInfoViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/15/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class SecretariatInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var sgLabel: UILabel!
    @IBOutlet weak var sgName: UILabel!
    @IBOutlet weak var sgEmail: UIButton!
    
    
    @IBOutlet weak var dgLabel: UILabel!
    @IBOutlet weak var dgName: UILabel!
    @IBOutlet weak var dgEmail: UIButton!
    
    
    var secretariatInfo: [SecretariatInfoResponse]!
    
    @IBAction func close(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func emailButton(_ sender: Any) {
        let email = (sender as! UIButton).currentTitle!
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("CIAC - Head Delegate Question")
            
            present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func call(_ sender: Any) {
        let fullNumber = (sender as! UIButton).currentTitle!
        var trimmedNumber = fullNumber.replacingOccurrences(of: "(", with: "")
        trimmedNumber = trimmedNumber.replacingOccurrences(of: ")", with: "")
        trimmedNumber = trimmedNumber.replacingOccurrences(of: " ", with: "")
        trimmedNumber = trimmedNumber.replacingOccurrences(of: "-", with: "")
        
        let numberURL = URL(string: "tel://\(trimmedNumber)")!
        UIApplication.shared.open(numberURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureLabels()

        // Do any additional setup after loading the view.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
//        sgLabel.text = secretariatInfo[0].role
        sgName.text = secretariatInfo[0].name
        sgEmail.setTitle(secretariatInfo[0].email, for: .normal)
        
        dgLabel.text = secretariatInfo[1].role
        dgName.text = secretariatInfo[1].name
        dgEmail.setTitle(secretariatInfo[1].email, for: .normal)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func configureLabels() {
//        print("configure")
//        scrapeInfo { secretariatInfoTuple in
//            self.secretariatInfoJSON = secretariatInfoTuple.0
//            self.meetings = secretariatInfoTuple.1
//        }
//    }
//
//    func scrapeInfo(completion: @escaping ((JSON, [MeetingItem])) -> Void) {
//        let config = URLSessionConfiguration.default
//        //config.waitsForConnectivity = true
//        let defaultSession = URLSession(configuration: config)
//        let url = URL(string: "https://thecias.github.io/CIAC/headDelData.json")
//        let request = NSMutableURLRequest(url: url!)
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//        var secretariatInfoJSON = JSON()
//        let task = defaultSession.dataTask(with: request as URLRequest) { data, response, error in
//            do {
//                print("Getting information from website")
//                if let error = error {
//                    print(error.localizedDescription)
//                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                    do {
//                        let dataJSON = try JSON(data: data)
//                        secretariatInfoJSON = dataJSON["secretariatInfo"]
//                    }
//                    catch { print(error)}
//                }
//            }
//            completion(secretariatInfoJSON)
//        }
//        task.resume()
//    }

}
