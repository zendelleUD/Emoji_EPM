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
    var emojiDataModel = EmojiDataModel()
    
    
    @IBOutlet weak var UserInput:UITextField!
    @IBOutlet weak var Emoji_Display: UILabel!
    
    
    var Emoji_String = ""
    var charEmojis = Set<String>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserInput.isEnabled = false
        
        
        // Do any additional setup after loading the view.
        
        /* Asychronous!! Runs in the background so makesure to time your functions with
         ex. Enable text box to appear all all functions regarding logic once the api request responds succesfully*/
        getNewEmojis(url: ResourceURL, count: count)
        


        
    }

    
    //MARK: - Networking
    /***********************************/

    func getNewEmojis(url: String,count: Int){
        
        var resource = url
        var tempJSON: JSON = ""
        
        
        resource.append("\(count)") //Takes the URL and Appends Count to make one string
        Alamofire.request(resource, method: .get).responseJSON {
            response in
            if response.result.isSuccess{   //response recieved
                
                // Takes the response that comes as an optional, force unwrap with "!"
                // Cast response.result.value! as a JSON
                let EmojiJSON : JSON = JSON(response.result.value!)
                
                self.UserInput.isEnabled = true
                tempJSON = EmojiJSON
                
                //Updates EMOJI array with new set of emojis.
                self.updateEmoji_Array(json: tempJSON)
                
            }else { //no response
                print("Error\(String(describing: response.result.error))")
                
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /*************************************************/
    func updateEmoji_Array(json: JSON){
        var tempArr = [String]()
        /*
        Gets Emoijis value and converts to an array,
        Then adds array elements to EMOJIS [String] var
        */
        for i in json["emojis"].arrayValue{
            tempArr.append(i.stringValue)
        }
        
        emojiDataModel.setEmojis(arr: tempArr)
        
        for i in json["emojis"].arrayValue{
            charEmojis.insert(i.stringValue)
        }
        
        print(emojiDataModel.emojis)
        Emoji_Display.text = "\(emojiDataModel.emojis)"
        Emoji_Display.sizeToFit()

    }
    
    
    //MARK: - IBAction User Input
    @IBAction func InputEdited(_ sender: UITextField) {
        
        
        
    }
    
    
    
}

