//
//  ViewController.swift
//  MultiplyGame
//
//  Created by Julian Panucci on 8/28/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:Outlets
    @IBOutlet weak var multiplicandLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctionsCorrectLabel: UILabel!
    @IBOutlet weak var correctOrWrongLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK:Constants
    let numberOfAnswers = 4
    let maxMultiplicand:UInt32 = 15
    let resultOffset = 5
    let questionsNeededToReset = 10
    
    let resetButtonTitle = "Reset"
    let nextButtonTitle = "Next"
    let startButtonTitle = "Start"
    let correctLabelText = "Correct 😊"
    let wrongLabelText = "Wrong 😔"
    let completedLabelText = "Woo! You did it! 😎"
    
    var answers = [Int]()
    var numberOfQuestionsCorrect = 0
    var totalQuestions = 0
    var result = 0
    var multiplicand = 0
    var multiplier = 0
    
    //MARK:Actions
    @IBAction func startAction(sender: AnyObject) {
        
        let button = sender as! UIButton
        if button.titleForState(.Normal) == resetButtonTitle {
            resetGame()
        }else {
            startButton.setTitle(nextButtonTitle, forState: .Normal)
            nextQuestion()
        }
        
    }
    @IBAction func selectedAnswer(sender: AnyObject) {
        let segmentControl = sender as! UISegmentedControl
        
        let correctAnswer = "\(result)"
        
        let selectedTitle = self.segmentControl.titleForSegmentAtIndex(segmentControl.selectedSegmentIndex)
        
        if correctAnswer == selectedTitle {
            correct()
        } else {
            wrong()
        }
         correctionsCorrectLabel.text = "\(numberOfQuestionsCorrect)/\(totalQuestions) Correct"
        
        updateProgressView()
    }
    
    //MARK:Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        segmentControl.removeAllSegments()
        for i in 0...numberOfAnswers - 1 {
            segmentControl.insertSegmentWithTitle("", atIndex: i, animated: true)
        }
        
        resetGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /**
     Displays the next equation to be solved by user.
     
     Answers are generated randomly and labels  are set for their respective value.
     
     Segment control loads the answers and becomes enabled for the user to select an answer
     */
    func nextQuestion()
    {
        
        totalQuestions += 1
        multiplicand = Int(arc4random_uniform(maxMultiplicand) + 1)
        multiplier = Int(arc4random_uniform(maxMultiplicand) + 1)
        result = multiplier * multiplicand
        
        let max = result + resultOffset
        let min = result - resultOffset
    
        answers.append(result)
        for _ in 0...numberOfAnswers - 2{
            var wrongAnswer = Int(arc4random_uniform(UInt32(max - min + 1))) + min
            while answers.contains(wrongAnswer){
                wrongAnswer = Int(arc4random_uniform(UInt32(max - min + 1))) + min
            }
            answers.append(wrongAnswer)
        }
        answers.shuffle()
        
        multiplierLabel.text = "\(multiplier)"
        multiplicandLabel.text = "\(multiplicand)"
        resultLabel.text = "\(result)"
        multiplierLabel.hidden = false
        multiplicandLabel.hidden = false
        resultLabel.hidden = true
        
        correctOrWrongLabel.hidden = true
        
        self.segmentControl.enabled = true
        self.segmentControl.selectedSegmentIndex = -1
        self.segmentControl.tintColor = UIColor.blueColor()
        
        for i in 0...numberOfAnswers - 1 {
            segmentControl.setTitle("\(answers[i])", forSegmentAtIndex: i)
        }
        answers.removeAll()
        self.startButton.enabled = false
        
        if totalQuestions == questionsNeededToReset {
            
            startButton.setTitle(resetButtonTitle, forState: .Normal)
            self.correctOrWrongLabel.text = completedLabelText
        }
       
    }
    
    /**
     Called when answer selected is correct. 
     
     Disables segement control and shows appropriate labels that were hidden with appropriate text and green color.
     
     Enables start button to proceed to next question
     
     Updates progress view and changes color relative to the number of questions correct
     */
    func correct()
    {
        self.segmentControl.enabled = false
        self.segmentControl.tintColor = UIColor.greenColor()
        
        correctOrWrongLabel.hidden = false
        correctOrWrongLabel.text = correctLabelText
        correctOrWrongLabel.textColor = UIColor.greenColor()
        resultLabel.hidden = false
        
        numberOfQuestionsCorrect += 1
       
        
        self.startButton.enabled = true
        
        
    }
    
    /**
      Called when the answer selected is incorrect. Disables the segment control and shows appropriate labels that were once hidden with appropriate text and red color. Enables start button to proceed to next question
     */
    func wrong()
    {
        self.segmentControl.enabled = false
        self.segmentControl.tintColor = UIColor.redColor()
        
        correctOrWrongLabel.text = wrongLabelText
        correctOrWrongLabel.textColor = UIColor.redColor()
        correctOrWrongLabel.hidden = false
        
        self.startButton.enabled = true
        
    }
    
    /**
     Resets the game to its original state, with labels hidden, segment control disabled with no titles, and the start button labeled "Start"
     */
    func resetGame()
    {
        numberOfQuestionsCorrect = 0
        totalQuestions = 0
        
        correctionsCorrectLabel.text = "\(numberOfQuestionsCorrect)/\(totalQuestions) Correct"
        
        for i in 0..<segmentControl.numberOfSegments {
            segmentControl.setTitle("", forSegmentAtIndex: i)
        }
        self.startButton.setTitle(startButtonTitle, forState: .Normal)
   
        self.multiplicandLabel.hidden = true
        self.multiplierLabel.hidden = true
        self.resultLabel.hidden = true

        self.correctOrWrongLabel.hidden = true
        
        self.segmentControl.enabled = false
        self.segmentControl.selectedSegmentIndex = -1
        self.segmentControl.tintColor = UIColor.blueColor()
        
        self.progressView.setProgress(0.0, animated: true)
        self.progressView.tintColor = UIColor.redColor()
        
    }
    
    /**
     Updates the display for the progress view and is animated
     */
    func updateProgressView()
    {
        let progress = (Float(totalQuestions)/Float(questionsNeededToReset))
        if progress == 0.5 {
            self.progressView.tintColor = UIColor.orangeColor()
        }
        if progress == 1.0 {
            self.progressView.tintColor = UIColor.greenColor()
        }
        self.progressView.setProgress(progress, animated: true)
    }

}

extension Array {
    /**
     Shuffles the elements of an array. Created as an extenstion so can be used on any type of array
     */
    mutating func shuffle()
    {
        for i  in 0...count {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if j != i {
                swap(&self[i], &self[j])
            }
        }
    }
}

