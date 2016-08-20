//
//  Trivia.swift
//  QuizApp
//
//  Created by Mark Erickson on 7/29/16.
//  Copyright © 2016 Mark Erickson. All rights reserved.
//

import Foundation

class Trivia {
    
    let question: String
    let answers: [String]
    let correctAnswer: Int
    
    init(question: String, answers: [String], correctAnswer: Int) {
        self.question = question
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}


