//
//  main.swift
//  XAXB
//
//  Created by 李松錡 on 2016/4/22.
//  Copyright © 2016年 李松錡. All rights reserved.
//

import Foundation

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    let rawString = NSString(data: inputData, encoding:NSUTF8StringEncoding)
    if let string = rawString {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    } else {
        return "Invalid input"
    }
}

func getAnswer() -> (Int, Int) {
    print("Enter number of As:")
    let a = input()
    print("Enter number of Bs:")
    let b = input()
    
    return (Int(a)!, Int(b)!)
}

class AnswerMgr {
    struct Record {
        let guess: Answer
        let userAnswer: (Int, Int)
    }
    
    var answers = [Answer]()
    var records = [Record]()
    
    init() {
        func generateCombination() -> [ [Int] ] {
            var ansCombinations = [[Int]]()
            for i in 1...960 {
                let binaryStr = String(i, radix: 2)
                var counter = 0
                for bit in binaryStr.characters {
                    if bit == "1" {
                        counter += 1
                    }
                }
                if counter == 4 {
                    let charCount = binaryStr.characters.count
                    let startIdx = 10 - charCount
                    var answer = [Int]()
                    for (idx, bit) in binaryStr.characters.enumerate() {
                        if bit == "1" {
                            answer.append(idx + startIdx)
                        }
                    }
                    ansCombinations.append(answer)
                }
            }
            return ansCombinations
        }
        
        func generatePermutation(numberSet: [Int], previous: [Int] = [Int]()) -> [ Answer ] {
            var partialPermutation = [Answer]()
            if numberSet.count == 1 {
                let answer = Answer(answer: previous + numberSet)
                partialPermutation.append(answer)
                return partialPermutation
            } else {
                for (idx, number) in numberSet.enumerate() {
                    var currentPart = previous
                    currentPart.append(number)
                    
                    var nextSet = numberSet
                    nextSet.removeAtIndex(idx)
                    
                    partialPermutation += generatePermutation(nextSet, previous: currentPart)
                }
            }
            return partialPermutation
        }

        for combination in generateCombination() {
            answers += generatePermutation(combination)
        }
    }
    
    var currentGuess: String? {
        get {
            if self.answers.count != 0 {
                return self.answers[0].value
            } else {
                return nil
            }
        }
    }

    func eliminateAnswers(userAnswer: (Int, Int)) {
        let previousGuess = self.answers[0]
        self.records.append(Record(guess: previousGuess, userAnswer: userAnswer))
        var removeIndices = [Int]()
        var offsetIdx = 0
        for (idx, guess) in self.answers.enumerate() {
            if !previousGuess.check(userAnswer.0, numberOfB: userAnswer.1, answer: guess) {
                removeIndices.append(idx - offsetIdx)
                offsetIdx += 1
            }
        }

        for idx in removeIndices {
            self.answers.removeAtIndex(idx)
        }
    }
    
    func printRecords() {
        for record in self.records {
            print("guess: \(record.guess.value), get answer: \(record.userAnswer)")
        }
    }
}

class Answer {
    var answer = [Int]()
    init(answer: [Int]) {
        self.answer = answer
    }
    func check(numberOfA: Int, numberOfB: Int, answer: Answer) -> Bool {
        var a = 0
        var b = 0
        for (myIdx, myNumber) in self.answer.enumerate() {
            for (compareIdx, compareNumber) in answer.answer.enumerate() {
                if myNumber == compareNumber {
                    if myIdx == compareIdx {
                        a += 1
                    } else {
                        b += 1
                    }
                }
            }
        }
        return (a == numberOfA) && (b == numberOfB)
    }
    var value: String {
        get {
            var str = ""
            for number in answer {
                str += String(number)
            }
            return str
        }
    }
}

var answerMgr = AnswerMgr()

var userAnswer: (Int, Int)
repeat {
    if let currentGuess = answerMgr.currentGuess {
        print("I guess the number you're thinking is \(currentGuess)")
    } else {
        print("Is there some mistake during the process? please check the record:")
        answerMgr.printRecords()
        break
    }

    userAnswer = getAnswer()

    answerMgr.eliminateAnswers(userAnswer)
} while(userAnswer != (4, 0))