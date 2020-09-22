//
//  ViewController.swift
//  Project5
//
//  Created by Kory Porter on 16/9/20.
//  Copyright © 2020 Kory Porter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(startGame)
        )
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func promptForAnswer() {
        let alertController = UIAlertController(
            title: "Enter answer",
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addTextField()
        
        let submitAction = UIAlertAction(
            title: "Submit",
            style: .default
        ) { [weak self, weak alertController] _ in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func submit(_   answer: String) {
        let lowerAnswer = answer.lowercased()

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isLongEnough(word: lowerAnswer) {
                        usedWords.insert(lowerAnswer, at: 0)

                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)

                        return
                    } else {
                        errorTitle = "Word is too short"
                        errorMessage = "It needs to be atleast 3 characters long!"
                    }
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }
        
        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func amountOfLetters(inside word: String, letter: String.Element) -> Int {
        let amountOfTimesLetterAppearsInWord = word.reduce(0) { (res, letterInternal) -> Int in
            if letter == letterInternal {
                return res + 1
            }
            return res
        }
        
        return amountOfTimesLetterAppearsInWord
    }
    
    func isPossible(word: String) -> Bool {
        // for each letter in the word we need to make sure it exists somewhere in the current word and that it hasn't used more than is availble in the word, e.g. you can't use two c's if the jumbled word it kact...
        
        if word.count > title!.count {
            print("The word entered has \(word.count) characters while the jumbled word has \(title!.count) characters.")
            return false
        }
        
        for letter in word {
            
            let amountOfTimesLetterAppearsInUsersWord = amountOfLetters(inside: word, letter: letter)
            let amountOfTimesLetterAppearsInJumbledWord = amountOfLetters(inside: title!, letter: letter)
            
            if amountOfTimesLetterAppearsInJumbledWord < 1 {
                print("The character \(letter) does not appear in the jumbled word at all.")
                return false
            }
            
            if amountOfTimesLetterAppearsInUsersWord > amountOfTimesLetterAppearsInJumbledWord {
                print("The character \(letter) was used \(amountOfTimesLetterAppearsInUsersWord) times, but only appears in the jumbled word \(amountOfTimesLetterAppearsInJumbledWord) times.")
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        if (word == title!.lowercased()) {
            return false
        }

        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}

