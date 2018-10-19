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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
