//
//  MeetingDetailViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/1/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class MeetingDetailViewController: UIViewController {

    var event: MeetingItem?
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = event?.date
        label.text = event?.description
        label.sizeToFit()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }   

}
