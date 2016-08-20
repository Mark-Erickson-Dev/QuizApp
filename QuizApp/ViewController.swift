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
    
    var startSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var incorrectSound: SystemSoundID = 2
    
    let incorrectColor = UIColor.orangeColor()
    let correctColor = UIColor(red: 0/255.0, green: 147/255.0, blue: 135/255.0, alpha: 1.0)
    
    let trivia = TriviaSet().allTrivia
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup game
        loadGameSounds()
        resultLabel.text = ""
        setupButtons()
        
        // Start game
        playGameSound(startSound)
        displayQuestion()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayQuestion() {
        
        enableButtons()
        
        // Select a random index for a question that is not repeated in a single game
        repeat {
            
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
            
        } while questionIndexes.contains(indexOfSelectedQuestion) == true
        
        // Add the index to the questionIndexes array
        questionIndexes.append(indexOfSelectedQuestion)
        
        // Display the question determined by the indexOfSelectedQuestion
        let selectedTrivia = trivia[indexOfSelectedQuestion]
        questionLabel.text = selectedTrivia.question
        
        // Display the possible answers determined by the indexOfSelectedQuestion
        answer1Button.setTitle(selectedTrivia.answers[0], forState: .Normal)
        answer2Button.setTitle(selectedTrivia.answers[1], forState: .Normal)
        answer3Button.setTitle(selectedTrivia.answers[2], forState: .Normal)
        answer4Button.setTitle(selectedTrivia.answers[3], forState: .Normal)
        
        // Show the playAgainButton
        playAgainButton.hidden = true
        
    }
    
    func displayScore() {
        
        // Hide the answer buttons
        answer1Button.hidden = true
        answer2Button.hidden = true
        answer3Button.hidden = true
        answer4Button.hidden = true
        
        // Display playAgainButton
        playAgainButton.hidden = false
        
        let score = Double(correctQuestions)/Double(questionsPerRound)
        
        // Create a result message to display the score, which will vary according
        // to how well the player did
        var resultMessage = ""
        resultLabel.textColor = UIColor.cyanColor()
        
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
        
        // Prevent button spamming while the answer is checked
        disableButtons()
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        resultLabel.hidden = false
        
        // Get the question determined by the indexOfSelectedQuestion, as well as the correct answer
        let selectedTrivia = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedTrivia.correctAnswer
        
        // Display the results for a correct answer and increment correctAnswers count
        if (sender === answer1Button && answer1Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer2Button && answer2Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer3Button && answer3Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1] ||
            sender === answer4Button && answer4Button.titleLabel?.text == selectedTrivia.answers[correctAnswer - 1]) {
            correctQuestions += 1
            resultLabel.textColor = correctColor
            resultLabel.text = "Correct!"
            playGameSound(correctSound)
        
        // Display the results for an incorrect answer; also display the correct answer
        } else {
            resultLabel.textColor = incorrectColor
            resultLabel.text = "Sorry, wrong answer! The correct answer is \(selectedTrivia.answers[correctAnswer - 1])"
            playGameSound(incorrectSound)
        }
        
        // Move on to the next round
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
        
        // Reset counter variables, and move on to the next round
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        
    }
    
    // MARK: Helper Methods
    
    func setupButtons() {
        
        // Round the corners of all the buttons
        answer1Button.layer.cornerRadius = 5
        answer2Button.layer.cornerRadius = 5
        answer3Button.layer.cornerRadius = 5
        answer4Button.layer.cornerRadius = 5
        playAgainButton.layer.cornerRadius = 5
        
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
    
    func loadGameSounds() {
        
        // Get the sound file and create an object for each game sound
        
        let pathToGameSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let gameSoundURL = NSURL(fileURLWithPath: pathToGameSoundFile!)
        AudioServicesCreateSystemSoundID(gameSoundURL, &startSound)
        
        let pathToCorrectSoundFile = NSBundle.mainBundle().pathForResource("chime_up", ofType: "wav")
        let correctSoundURL = NSURL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL, &correctSound)
        
        let pathToIncorrectSoundFile = NSBundle.mainBundle().pathForResource("blip", ofType: "wav")
        let incorrectSoundURL = NSURL(fileURLWithPath: pathToIncorrectSoundFile!)
        AudioServicesCreateSystemSoundID(incorrectSoundURL, &incorrectSound)
        
    }
    
    func playGameSound(gameSound: SystemSoundID) {
        
        // Play the sound file designated by the ID passed in
        AudioServicesPlaySystemSound(gameSound)
        
    }
    
    func disableButtons() {
        
        answer1Button.enabled = false
        answer2Button.enabled = false
        answer3Button.enabled = false
        answer4Button.enabled = false
        
    }
    
    func enableButtons() {
        
        answer1Button.enabled = true
        answer2Button.enabled = true
        answer3Button.enabled = true
        answer4Button.enabled = true
        
    }

}

