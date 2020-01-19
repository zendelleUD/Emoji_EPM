//
//  Emoji.swift
//  Zappos_EmojiPerMinute
//
//  Created by John on 1/17/20.
//  Copyright © 2020 Zendelle_Badiang. All rights reserved.
//

import Foundation

enum EmojiError: Error{
    case noEmoji, notAnEmoji
}

struct Emojiresponse:Decodable {
    var response:[Emojis]
}

struct Emojis: Decodable {
    var emoji:String
}
