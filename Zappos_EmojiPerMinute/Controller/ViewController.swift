//
//  ViewController.swift
//  Zappos_EmojiPerMinute
//
//  Created by John on 1/17/20.
//  Copyright © 2020 Zendelle_Badiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    //Constants
    var count = 10
    var ResourceURL = "https://emojigenerator.herokuapp.com/emojis/api/v1?count="
    
    @IBOutlet weak var UserInput:UITextField!
    @IBOutlet weak var Emoji_Display: UILabel!
    
    var EMOJIS: [String] = []
    var Emoji_String: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getEmojis(url: ResourceURL, count: count)
        for element in EMOJIS{
            Emoji_String += element
        }
        Emoji_Display.text = Emoji_String
        print(Emoji_String)
        
        
    }

    
    //MARK: - Networking
    /***********************************/

    func getEmojis(url: String,count: Int){
        
        var resource = url
        resource.append("\(count)") //Takes the URL and Appends Count to make one string
        Alamofire.request(resource, method: .get).responseJSON {
            response in
            if response.result.isSuccess{//response recieved
                
                // Takes the response that comes as an optional, force unwrap with "!"
                // Cast response.result.value! as a JSON
                let EmojiJSON : JSON = JSON(response.result.value!)
                
                self.updateEmoji_Array(json: EmojiJSON)
//                print(EmojiJSON["emojis"])
//                for element in self.EMOJIS{
//                    print(element)
//                }
                
            }else { //no response
                print("Error\(String(describing: response.result.error))")
                
            }
        }
        
    }
    
    //MARK: - JSON Parsing
    /*************************************************/
    func updateEmoji_Array(json: JSON){
        
        //Turns JSON[emojis] into strings and adds to an array
        if let emojiResult = json["emojis"].rawString(){
            EMOJIS.append(emojiResult)
        }
    }
    
    
    
    @IBAction func InputEdited(_ sender: UITextField) {
        
        print("called")
        
    }
}

