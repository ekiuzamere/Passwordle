//
//  Guess.swift
//  Passwordle!
//
//  Created by Eki Uzamere on 1/7/23.
//

import SwiftUI

struct Guess {
    let index: Int
    var word = "     " // string of five colors, initially just five spaces
    var bgColors = [Color](repeating: .wrong, count: 5) //background of square is initially bkgrnd color
    var cardFlipped = [Bool](repeating: false, count: 5) //cardFlipped array will be all initially false
    
    /* want to break out word into an array, so we can iterate through and compare each letter
     */
    
    var guessLetters: [String] {
        word.map { String($0) } // mapping each character of the word and converting it to a string
    }
    //⬛🟩⬛🟨⬛
    var results: String {
        let tryColors: [Color: String] = [.misplaced : "🟨",
                                          .correct : "🟩",
                                          .wrong : "⬛"]
        return bgColors.compactMap {tryColors[$0]}.joined(separator: "")
    }
    
}
