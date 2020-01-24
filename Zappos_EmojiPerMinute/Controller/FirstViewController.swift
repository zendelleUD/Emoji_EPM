//
//  FirstViewController.swift
//  Zappos_EmojiPerMinute
//
//  Created by John on 1/23/20.
//  Copyright © 2020 Zendelle_Badiang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstToSecond"{
            
            let destinationViewController = segue.destination as! ViewController
            
        }
    }
   

}
