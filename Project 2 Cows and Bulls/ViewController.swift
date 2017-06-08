//
//  ViewController.swift
//  Project 2 Cows and Bulls
//
//  Created by Marc Aupont on 6/7/17.
//  Copyright © 2017 Digimark Technical Solutions. All rights reserved.
//

import Cocoa
import GameplayKit

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var guess: NSTextField!
    
    var answer = ""
    var guesses = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startNewGame()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return guesses.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let vw = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
        if tableColumn?.title == "Guess" {
            
            vw.textField?.stringValue = guesses[row]
            
        } else {
            
            vw.textField?.stringValue = result(for: guesses[row])
        }
        
        return vw
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        return false
    }
    
    func result(for guess: String) -> String {
        
        var bulls = 0
        var cows = 0
        
        let guessedLetters = Array(guess.characters)
        
        let answerLetters = Array(answer.characters)
        
        for (index, letter) in guessedLetters.enumerated() {
            
            if letter == answerLetters[index] {
                
                bulls += 1
                
            } else if answerLetters.contains(letter) {
                
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    func startNewGame() {
        
        guess.stringValue = ""
        guesses.removeAll()
        var numbers = Array(0...9)
        
        numbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers) as! [Int]
        
        for _ in 0 ..< 4 {
            
            answer.append(String(numbers.removeLast()))
        }
        
        tableView.reloadData()
    }

    @IBAction func submitGuess(_ sender: Any) {
        
        
        //check to ensure there are 4 unique characters
        let guessString = guess.stringValue
        
        guard Set(guessString.characters).count == 4 else { return }
        
        //ensure there are no non-digit characters
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        
        guard guessString.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        //add the guess to the array and table view
        guesses.insert(guessString, at: 0)
        
        tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)
        
        guess.stringValue = ""
        
        let resultString = result(for: guessString)
        
        if resultString.contains("4b") {
            
            let alert = NSAlert()
            
            if guesses.count < 10 {
                
                alert.messageText = "You win"
                alert.informativeText = "Congrats! You did it in \(guesses.count) moves. Impressive!"
                alert.runModal()
                
                //Wont get executed until users clicks a button from runModal call
                startNewGame()
                
            } else if 10 ... 20 ~= guesses.count {
                
                alert.messageText = "You win"
                alert.informativeText = "Congrats! You did it in \(guesses.count) moves. Lets try to improve on that!"
                alert.runModal()
                
                //Wont get executed until users clicks a button from runModal call
                startNewGame()
                
            } else {
                
                alert.messageText = "You win"
                alert.informativeText = "Congrats! You did it in \(guesses.count) moves. I mean you won but, come on!"
                alert.runModal()
                
                //Wont get executed until users clicks a button from runModal call
                startNewGame()

            }
            
        }
    }

}

