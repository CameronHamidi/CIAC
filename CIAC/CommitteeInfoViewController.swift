//
//  CommitteeInfoViewController.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/15/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import UIKit

class CommitteeInfoViewController: UIViewController {

    
    @IBOutlet weak var committeeImage: UIImageView!
    @IBOutlet weak var scheduleTextView: UITextView!
    var committee: RoomItem?
    var scheduleText: String?
    @IBOutlet weak var committeeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.title = committee!.committee
        scheduleTextView.text = scheduleText!
        committeeImage.image = UIImage(named: committee!.image)
        committeeLabel.text = committee!.committee
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
