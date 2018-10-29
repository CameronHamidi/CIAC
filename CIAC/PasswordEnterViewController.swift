//
//  PasswordEnterViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/7/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

protocol EnterPassword: class {
    func enterPassword(enterPassword: String, correctPassword: Bool, passwordType: String)
}

class PasswordEnterViewController: UIViewController {

    var viewControllerDelegate: ViewController?
    var correctPassword: String?
    var passwordType: String?
    
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordEnterField: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        print("button press: \(correctPassword!)")
        if passwordEnterField.text == correctPassword! {
            if viewControllerDelegate != nil {
                viewControllerDelegate!.enterPassword(enterPassword: passwordEnterField.text!, correctPassword: true, passwordType: passwordType!)
            }
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
        passwordLabel.text = "Enter the \(passwordType!) password:"
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
