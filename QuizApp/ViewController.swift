//
//  ViewController.swift
//  QuizApp
//
//  Created by Mark Erickson on 7/24/16.
//  Copyright © 2016 Mark Erickson. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionLabel.text = questionDictionary["Question"]
        
        //dispatch_async(dispatch_get_main_queue()){
            //self.setupAnswers()
        //}
        
        actionButton.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        answer1Button.hidden = true
        answer2Button.hidden = true
        answer3Button.hidden = true
        answer4Button.hidden = true
        
        // Display play again button
        actionButton.hidden = false
        
        resultLabel.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        resultLabel.hidden = false
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === answer1Button &&  correctAnswer == "True") || (sender === answer2Button && correctAnswer == "False") {
            correctQuestions += 1
            resultLabel.text = "Correct!"
        } else {
            resultLabel.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            resultLabel.hidden = true
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        answer1Button.hidden = false
        answer2Button.hidden = false
        answer3Button.hidden = false
        answer4Button.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    
    
    // MARK: Helper Methods
    
    func setupAnswers() {
        answer1Button.titleLabel?.text = "True"
        answer2Button.titleLabel?.text = "False"
    }
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

