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
        // initialize all possible answers
    }
}

class Answer {
    var answer = [Int]()
    init(answer: [Int]) {
        self.answer = answer
    }
    func check(numberOfA: Int, numberOfB: Int, answer: [Int]) -> Bool {
        // check is number of As and Bs are the same
        return true
    }
}