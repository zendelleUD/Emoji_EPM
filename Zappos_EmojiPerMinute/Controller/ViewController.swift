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
    @IBOutlet weak var WordPerMinuteLabel: UILabel!
    
    //Variables
    var Emoji_String = ""
    var charEmojis = Set<String>()
    var score: Int = 0
    var totalKeyStrokes: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UITextField
        UserInput.sizeToFit()
        
        WordPerMinuteLabel.sizeToFit()
        
        
        
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
                
                self.UserInput.becomeFirstResponder()
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
            Emoji_String += i.stringValue
        }
        
        emojiDataModel.setEmojis(arr: tempArr)
        
        print(emojiDataModel.emojis)
        Emoji_Display.text = Emoji_String
        Emoji_Display.sizeToFit()

    }
    
    
    //MARK: - IBAction User Input
    /**
            Everytime UITextField is changed, checks if Emoji_String has substring Sender.Text
        Function:
     Counts totalKeyStrokes
     Count total Correct Matches
     Starts timer if not already started
     @return void
     */
    @IBAction func InputEdited(_ sender: UITextField) {
        
        /*
         sudo code: checks if a timer exists, instances one if not
         */
        
        if Emoji_String.hasPrefix(sender.text!){
            score += 1
        }
        else{
            score -= 1
        }
        totalKeyStrokes += 1
        print(score)
        print(totalKeyStrokes)
        emojiPerMinute(totalKeyStrokes: totalKeyStrokes, correctKeys: totalKeyStrokes-1)
        
    }
    
    
    //MARK: - Emoji Per Minute Calculator
    /**
     Number_of_keystroke / time_in_minute * percentages_of_accurate_EMOJI
     */
    func emojiPerMinute(totalKeyStrokes: Int, correctKeys: Int){
        
        let epm = Double(totalKeyStrokes / 1 * correctKeys)
        let remainder = epm.truncatingRemainder(dividingBy: 1)
        if remainder >= 0.5{
            WordPerMinuteLabel.text =  "\(epm + Double(1 - remainder))) EMP"
        }
        else{
            WordPerMinuteLabel.text =  "\(epm) EPM"
        }
        
    }
    
    
}

