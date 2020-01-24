//
//  ThirdViewController.swift
//  Zappos_EmojiPerMinute
//
//  Created by John on 1/23/20.
//  Copyright © 2020 Zendelle_Badiang. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController{
   
    
    
    
    //MARK: - VARIABLES
    var currentWPM: String?
    var delegate: CanRecieve?
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var EPMLabel: UILabel!
    
    @IBOutlet weak var CloseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        EPMLabel.text = currentWPM
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        exit(-1)
    }
    
    



}
