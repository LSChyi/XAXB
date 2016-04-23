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
    var answers = [Answer]()
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

var userAnser: (Int, Int)
repeat {
    if let currentGuess = answerMgr.currentGuess {
        print("I guess the number you're thinking is \(currentGuess)")
    } else {
        print("Is there some mistake during the process? check the record:")
        // print record
        break
    }

    userAnser = getAnswer()

} while(userAnser != (4, 0))