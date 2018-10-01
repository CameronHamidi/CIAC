//
//  HeadDelPasswordEnterViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/7/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

protocol EnterHeadDelPassword: class {
    func enterHeadDelPassword(enterPassword: String, correctPassword: Bool)
}

class HeadDelPasswordEnterViewController: UIViewController {

    var delegate: ViewController?
    var correctPassword: String?
    
    @IBOutlet weak var passwordEnterField: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        print("button press: \(correctPassword!)")
        if passwordEnterField.text == correctPassword! {
            delegate?.enterHeadDelPassword(enterPassword: passwordEnterField.text!, correctPassword: true)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Incorrect Password", message: "Please enter the correct password. If you have forgotten the password, contact the Secretary-General or Director-General", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("correct : \(correctPassword!)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
