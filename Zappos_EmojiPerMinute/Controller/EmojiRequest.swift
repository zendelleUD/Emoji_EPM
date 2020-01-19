//
//  EmojiRequest.swift
//  Zappos_EmojiPerMinute
//
//  Created by John on 1/17/20.
//  Copyright © 2020 Zendelle_Badiang. All rights reserved.
//

//https://emojigenerator.herokuapp.com/emojis/api/v1?count=40

import Foundation

struct EmojiRequest{
    let resourceURL:URL
    
    init(Count:Int){
        
        let resourceString = "https://emojigenerator.herokuapp.com/emojis/api/v1?count=\(Count) "
    
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
        
    }
    
}
