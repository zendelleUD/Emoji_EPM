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
   
    //Timer
    var timer:Timer?
    var seconds = 1
    var timeLeft = 5
    
    //Outlets
    @IBOutlet weak var UserInput:UITextField!
    @IBOutlet weak var Emoji_Display: UILabel!
    @IBOutlet weak var WordPerMinuteLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var EPMfunc: UIButton!
    

    //Variables
    var Emoji_String = ""
    var charEmojis = Set<Character>()
    var score: Int = 0
    var totalKeyStrokes: Int = 0
    var epmCorrect: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UITextField
        UserInput.sizeToFit()
        
        WordPerMinuteLabel.sizeToFit()
        
        
        
        /* Asychronous!! Runs in the background so makesure to time your functions with
         ex. Enable text box to appear all all functions regarding logic once the api request responds succesfully*/
        getNewEmojis(url: ResourceURL, count: count)
        
        
        
    }

    
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoThirdScreen"{
            
            let destinationViewController = segue.destination as! ThirdViewController
            
            destinationViewController.currentWPM = WordPerMinuteLabel.text
        }
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
        
        for char in Emoji_String{
            charEmojis.insert(char)
        }
        
        print(charEmojis)
        
        emojiDataModel.setEmojis(arr: tempArr)
        
        print(emojiDataModel.emojis)
        Emoji_Display.text = Emoji_String
        Emoji_Display.sizeToFit()

    }
    
    
    
    
    @IBAction func changeEPM(_ sender: UIButton) {
        
        epmCorrect = false
        
        
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
    
    
    
    //TODO: Fix detection for correct user input
    //TODO: Do no recheck the same string that was already checked
    //Idea: Can remove any emojis that are input into UITextField
    @IBAction func InputEdited(_ sender: UITextField) {
        
        //MARK: Timer
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
        
        
        //MARK: CorrectKeyLogic
        /*
         Iterates through each character in UserInput.text
         to check if charEmojis contains any element.
         If so adds score and removes element within charEmohis set to avoid
         double scoring.
         */
        if UserInput.text != nil{
            for char in UserInput.text! {
                if charEmojis.contains(char){
                    score += 1
                    charEmojis.remove(char)
                    print("CharEmojisSet: \(charEmojis)")
                }
            }
        }
        
        totalKeyStrokes += 1

    
        //Checks
        if epmCorrect {
            emojiPerMinute(totalKeyStrokes: totalKeyStrokes, correctKeys: score)
        }
        else{
            emojiPerMinute(totalKeyStrokes: totalKeyStrokes)
        }
        
        
    
    }
    
    
    @objc func onTimerFires()
    {
        seconds += 1
        timeLeft -= 1
        TimeLabel.text = "Time: \(timeLeft) secs"
        /*Checks if timeleft is 0 or if the charlist is empty to then
         perform the segue*/
        if timeLeft <= 0 || charEmojis.isEmpty == true{
            timer?.invalidate()
            timer = nil
            performSegue(withIdentifier: "gotoThirdScreen", sender: self)
        }
    }
    
    
    //MARK: - Emoji Per Minute Calculator
    /**
     Number_of_keystroke / time_in_minute * percentages_of_accurate_EMOJI
     */
    func emojiPerMinute(totalKeyStrokes: Int, correctKeys: Int){
        
        let epm = Double(totalKeyStrokes) / Double(60) * (Double(correctKeys) / Double(totalKeyStrokes))
        let remainder = epm.truncatingRemainder(dividingBy: 1)
        if remainder >= 0.5{
            WordPerMinuteLabel.text =  "\(epm + Double(1 - remainder)) EMP"
        }
        else{
            WordPerMinuteLabel.text =  "\(epm) EPM"
        }
        
    }
    
    //OverLoaded Method to change
    func emojiPerMinute(totalKeyStrokes: Int){
       let epm =
        Double(totalKeyStrokes) / Double(seconds )
        
        let remainder = epm.truncatingRemainder(dividingBy: 1)
        if remainder >= 0.5{
            WordPerMinuteLabel.text =  "\(epm + Double(1 - remainder)) EMP"
        }
        else{
            WordPerMinuteLabel.text =  "\(epm) EPM"
        }
    }
    
}

