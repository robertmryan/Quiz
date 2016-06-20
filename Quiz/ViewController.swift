//
//  ViewController.swift
//  Quiz
//
//  Created by Robert Ryan on 6/20/16.
//  Copyright © 2016 Robert Ryan. All rights reserved.
//
// http://stackoverflow.com/questions/37759585

import UIKit

struct Question {
    let question: String
    let answers: [String]
    let correctAnswer: Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    lazy var buttons: [UIButton] = { return [self.button1, self.button2, self.button3, self.button4] }()
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var endLabel: UILabel!
    
    var questions: [Question] = [
        Question(
            question: "Hola familia, Cual es mi nombre?",
            answers: ["Cesar", "Karlos", "William", "Chiqui"],
            correctAnswer: 1),
        Question(
            question: "Hola famili, cual es mi apellido?",
            answers: ["Perez", "Carvajal", "Garcia", "Sanchez"],
            correctAnswer: 0),
        Question(
            question: "Quien hace la lachona mas rica?",
            answers: ["Willy", "Mario", "Karlos", "Juan David"],
            correctAnswer: 2),
        Question(
            question: "Quien hace las tartas mas lindas?",
            answers: ["Jili", "Carvajal", "Garcia", "Leidy y Liz"],
            correctAnswer: 3)
    ]
    
    var questionIndexes: [Int]!
    var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionIndexes = Array(0 ..< questions.count)  // builds an array [0, 1, 2, ... n]
        questionIndexes.shuffleInPlace()                // randomizes that list
        
        updateLabelsAndButtonsForIndex(0)
    }
    
    func updateLabelsAndButtonsForIndex(questionIndex: Int) {
        // if we're done, show message in `endLabel` and hide `nextButton`
        
        guard questionIndex < questions.count else {
            endLabel.hidden = false
            endLabel.text = "All done!"
            nextButton.hidden = true
            return
        }
        
        // update our property
        
        currentQuestionIndex = questionIndex
        
        // hide end label and next button
        
        hideEndLabelAndNextButton()
        
        // identify which question we're presenting
        
        let questionObject = questions[questionIndexes[questionIndex]]
        
        // update question label and answer buttons accordingly
        
        questionLabel.text = questionObject.question
        for (answerIndex, button) in buttons.enumerate() {
            button.setTitle(questionObject.answers[answerIndex], forState: .Normal)
        }
    }
    
    func hideEndLabelAndNextButton() {
        endLabel.hidden = true
        nextButton.hidden = true
    }
    
    func unhideEndLabelAndNextButton() {
        endLabel.hidden = false
        nextButton.hidden = false
    }
    
    // note, because I created that array of `buttons`, I now don't need
    // to have four `@IBAction` methods, one for each answer button, but
    // rather I can look up the index for the button in my `buttons` array
    // and see if the index for the button matches the index of the correct
    // answer.
    
    @IBAction func didTapAnswerButton(button: UIButton) {
        unhideEndLabelAndNextButton()
        
        let buttonIndex = buttons.indexOf(button)
        let questionObject = questions[questionIndexes[currentQuestionIndex]]
        
        if buttonIndex == questionObject.correctAnswer {
            endLabel.text = "Correcto"
        } else {
            endLabel.text = "Falso"
        }
    }
    
    @IBAction func didTapNextButton(sender: AnyObject) {
        updateLabelsAndButtonsForIndex(currentQuestionIndex + 1)
    }
    
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0 ..< count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
