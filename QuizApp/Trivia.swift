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

struct TriviaSet {
    let trivia: [Trivia] = [trivia1, trivia2, trivia3, trivia4, trivia5, trivia6, trivia7, trivia8, trivia9, trivia10]
}

let trivia1 = Trivia(question: "This was the only US President to serve more than two consecutive terms.",
                     answers: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"],
                     correctAnswer: 2)
let trivia2 = Trivia(question: "Which of the following countries has the most residents?",
                     answers: ["Nigeria", "Russia", "Iran", "Vietnam"],
                     correctAnswer: 1)
let trivia3 = Trivia(question: "In what year was the United Nations founded?",
                     answers: ["1918", "1919", "1945", "1954"],
                     correctAnswer: 3)
let trivia4 = Trivia(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                     answers: ["Paris", "Washington D.C.", "New York City", "Boston"],
                     correctAnswer: 3)
let trivia5 = Trivia(question: "Which nation produces the most oil?",
                     answers: ["Iran", "Iraq", "Brazil", "Canada"],
                     correctAnswer: 4)
let trivia6 = Trivia(question: "Which country has most recently won consecutive World Cups in Soccer?",
                     answers: ["Italy", "Brazil", "Argetina", "Spain"],
                     correctAnswer: 2)
let trivia7 = Trivia(question: "Which of the following rivers is longest?",
                     answers: ["Yangtze", "Mississippi", "Congo", "Mekong"],
                     correctAnswer: 2)
let trivia8 = Trivia(question: "Which city is the oldest?",
                     answers: ["Mexico City", "Cape Town", "San Juan", "Sydney"],
                     correctAnswer: 1)
let trivia9 = Trivia(question: "Which country was the first to allow women to vote in national elections?",
                     answers: ["Poland", "United States", "Sweden", "Senegal"],
                     correctAnswer: 1)
let trivia10 = Trivia(question: "Which of these countries won the most medals in the 2012 Summer Games?",
                      answers: ["France", "Germany", "Japan", "Great Britian"],
                      correctAnswer: 4)
