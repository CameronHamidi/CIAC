//
//  AddressViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {

    
    @IBOutlet weak var addressTextView: UITextView!
    var addresses: [AddressItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var addressText = ""
        for address in addresses {
            addressText += address.name + ":\n" + address.address + "\n\n"
        }
        addressTextView.text = addressText
        // Do any additional setup after loading the view.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
