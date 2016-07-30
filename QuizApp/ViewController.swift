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
    
    let questionsPerRound = 5
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var questionIndexes = [Int]()
    
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var incorrectSound: SystemSoundID = 2
    
    let trivia = TriviaSet().trivia
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameSounds()
        // Start game
        resultLabel.text = ""
        playGameStartSound()
        displayQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        
        repeat {
            
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
            
        } while questionIndexes.contains(indexOfSelectedQuestion) == true
        
        questionIndexes.append(indexOfSelectedQuestion)
        print("questionIndexes.count \(questionIndexes.count)")
        
        print(questionIndexes)
        
        let selectedTrivia = trivia[indexOfSelectedQuestion]
        questionLabel.text = selectedTrivia.question
        
        answer1Button.setTitle(selectedTrivia.answers[0], forState: .Normal)
        answer2Button.setTitle(selectedTrivia.answers[1], forState: .Normal)
        answer3Button.setTitle(selectedTrivia.answers[2], forState: .Normal)
        answer4Button.setTitle(selectedTrivia.answers[3], forState: .Normal)
        
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
        
        let score = Double(correctQuestions)/Double(questionsPerRound)
        
        var resultMessage = ""
        
        if score >= 0.75 {
            resultMessage += "Way to go!\n"
        } else if score < 0.75 && score > 0.59 {
            resultMessage += "Not too shabby.\n"
        } else {
            resultMessage += "You need some work.\n"
        }
        
        resultMessage += "You got \(correctQuestions) out of \(questionsPerRound) correct."
        
        resultLabel.text = resultMessage
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        resultLabel.hidden = false
        
        let selectedTrivia = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedTrivia.correctAnswer
        
        if (sender === answer1Button && answer1Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer2Button && answer2Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer3Button && answer3Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer4Button && answer4Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1]) {
            correctQuestions += 1
            resultLabel.text = "Correct!"
            playCorrectSound()
            
        } else {
            resultLabel.text = "Sorry, wrong answer! The correct answer is \(selectedTrivia.answers[correctAnswer - 1])"
            playIncorrectSound()
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            questionIndexes.removeAll()
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
    
    func loadGameSounds() {
        let pathToGameSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let gameSoundURL = NSURL(fileURLWithPath: pathToGameSoundFile!)
        AudioServicesCreateSystemSoundID(gameSoundURL, &gameSound)
        
        let pathToCorrectSoundFile = NSBundle.mainBundle().pathForResource("chime_up", ofType: "wav")
        let correctSoundURL = NSURL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL, &correctSound)
        
        let pathToIncorrectSoundFile = NSBundle.mainBundle().pathForResource("blip", ofType: "wav")
        let incorrectSoundURL = NSURL(fileURLWithPath: pathToIncorrectSoundFile!)
        AudioServicesCreateSystemSoundID(incorrectSoundURL, &incorrectSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
}

