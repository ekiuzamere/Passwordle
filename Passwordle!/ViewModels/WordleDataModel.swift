//
//  WordleDataModel.swift
//  Passwordle!
//
//  Created by Eki Uzamere on 1/7/23.
//

import SwiftUI

class WordleDataModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    @Published var toastText: String?
    @Published var showStats = false
    
    
    var keyColors = [String : Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var selectedWord = ""
    var currentWord = ""
    var randomInt = 0 //mine
    var tryIndex = 0
    var inPlay = false
    var unlock = false
    var gameOver = false
    var toastWords = ["Genius", "Magnificent", "Impressive", "Splendid", "Great", "Phew"]
    var currentStat: Statistic
    
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool {
        !inPlay || currentWord.count == 5
    }
    
    init() {
        currentStat = Statistic.loadStat()
        newGame()
    }
    
    func newGame() {
        populateDefaults()
        randomInt = Int.random(in: 10000..<99999)
        selectedWord = String(randomInt)
        //selectedWord = "12345"
        currentWord = ""
        inPlay = true
        unlock = false
        tryIndex = 0
        gameOver = false
        print(selectedWord)
    }
    
    func populateDefaults() {
        guesses = []
        for index in 0...5 {
            guesses.append(Guess(index: index))
        }
        
        let letters = "1234567890"
        for char in letters {
            keyColors[String(char)] = .unused
        }
        matchedLetters = []
        misplacedLetters = []
    }
    
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        updateRow()
        
    }
    
    func enterWord() {
        if currentWord == selectedWord {
            gameOver = true
            print("You win")
            setCurrentGuessColors()
            currentStat.update(win: true, index: tryIndex)
            showToast(with: toastWords[tryIndex])
            inPlay = false
        } else if (currentWord != selectedWord) {
            
            //would be after verifying word
            setCurrentGuessColors()
            tryIndex += 1
            currentWord = ""
            if tryIndex == 6 {
                currentStat.update(win: false)
                gameOver = true
                inPlay = false
                showToast(with: selectedWord)
            } else {
                //animation
                withAnimation {
                    self.incorrectAttempts[tryIndex] += 1
                }
                
                incorrectAttempts[tryIndex] = 0
                
            }
            
        }
        
    }
    
    func removeLetterFromCurrentWord() {
        currentWord.removeLast()
        updateRow()
        
    }
    
    func updateRow() {
        let guessWord = currentWord.padding(toLength: 5, withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }
    
    func setCurrentGuessColors() {
        let correctLetters = selectedWord.map { String($0) }
        var frequency = [String : Int]()
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }
        for index in 0...4 {
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if guessLetter == correctLetter {
                guesses[tryIndex].bgColors[index] = .correct
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}) {
                        misplacedLetters.remove(at: index)
                    }
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correct
                && frequency[guessLetter]! > 0 {
                guesses[tryIndex].bgColors[index] = .misplaced
               // keyColors[guessLetter] = .misplaced // 7798
                if !misplacedLetters.contains(guessLetter)
                    && !matchedLetters.contains(guessLetter){
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplaced
                }
                frequency[guessLetter]! -= 1
            }
        }
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if keyColors[guessLetter] != .correct
                && keyColors[guessLetter] != .misplaced {
                keyColors[guessLetter] = .wrong
            }
        }
        flipCards(for: tryIndex)
        
    }
    
    func flipCards(for row: Int) {
        for col in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col) * 0.2) {
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }
    
    func showToast(with text: String?) {
        withAnimation {
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3)) {
            toastText = nil
            if gameOver {
                if (currentWord == selectedWord) {
                    unlock = true
                }
                
                withAnimation(Animation.linear(duration: 0.2).delay(3)) {
                    showStats.toggle()
                }
            }
        }
    }
    
    func shareResult() {
        let stat = Statistic.loadStat()
        let results = guesses.enumerated().compactMap { $0 }
        var guessString = ""
        for result in results {
            if result.0 <= tryIndex {
                guessString += result.1.results + "\n"
            }
        }
        let resultString = """
Passwordle \(stat.games) \(tryIndex < 6 ? "\(tryIndex + 1)/6" : "")
\(guessString)
"""
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2,
                                                                                  y: Global.screenHeight / 2,
                                                                                  width: 200, height: 200)
            
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        default:
            break
        }
    }
}
