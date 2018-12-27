//
//  StaffRoomDetailViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class StaffRoomDetailViewController: UIViewController {

    
    @IBOutlet weak var scheduleTextView: UITextView!
    var scheduleText: String
    
    required init?(coder aDecoder: NSCoder) {
        scheduleText = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTextView.text = scheduleText

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
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
