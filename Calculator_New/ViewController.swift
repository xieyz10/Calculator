//
//  ViewController.swift
//  Calculator_New
//
//  Created by Mingyuan Xie on 9/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputResult: UILabel!
    var digitStack = [Double]()
    var operatorStack = [String]()
    var integerValue:Int = 0
    var decimalValue:Double = 0
    var decimalFactor:Double = 10
    var numberOfOperator = 0
    var tempResult:Double = 0
    var lastOperator:String = ""
    var previousOperatorButton = ""
    var shouldCalculateDecimalValue = false
    var hasClickedOperatorButton = false
    var hasFinishedInput = false
    
    var removedDigitStack = [Double]()
    var removedOperatorStack = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func digitButton_Click(_ sender: UIButton) {
        if hasClickedOperatorButton && hasFinishedInput {
            outputResult.text = ""
        }
        let digit:Int! = Int(sender.titleLabel!.text!)
        if(shouldCalculateDecimalValue == false){
            integerValue = integerValue * 10 + digit
        }else{
            decimalValue += Double(digit)/decimalFactor
            decimalFactor *= 10
        }
        outputResult.text =
            outputResult.text == "0" ? String(digit): outputResult.text! + String(digit)
        hasFinishedInput = false
        hasClickedOperatorButton = false
    }
    
    @IBAction func decimalPointButton_Click(_ sender: RoundButton) {
        if shouldCalculateDecimalValue == false {
            shouldCalculateDecimalValue = true
            outputResult.text! += "."
        }
    }
    
    @IBAction func operatorButton_Click(_ sender: RoundButton) {
        var currentResult = Double(integerValue) + decimalValue
        if hasClickedOperatorButton == true {
            if (previousOperatorButton == "+" || previousOperatorButton == "-")
                && (sender.titleLabel!.text! == "*" || sender.titleLabel!.text! == "/"){
                if removedDigitStack.count >= 2{
                    let origialFirstValue = removedDigitStack.removeLast()
                    let origialSecondValue = removedDigitStack.removeLast()
                    digitStack.removeLast()
                    digitStack.append(origialFirstValue)
                    operatorStack.removeLast()
                    operatorStack.append(removedOperatorStack.removeLast())
                    currentResult = origialSecondValue
                    outputResult.text = String(currentResult)
                }
            }
            if (previousOperatorButton == "*" || previousOperatorButton == "/")
                && (sender.titleLabel!.text! == "+" || sender.titleLabel!.text! == "-"){
                currentResult = digitStack.removeLast()
                operatorStack.removeLast()
            }
        }
        hasClickedOperatorButton = true
        previousOperatorButton = sender.titleLabel!.text!
        let currentOperator:String = sender.titleLabel!.text!
        if digitStack.count == 0 {
            digitStack.append(currentResult)
            operatorStack.append(currentOperator)
        }else{
            digitStack.append(currentResult)
            print("current result is:" + String(currentResult))
            //check if previous operator is * or /
            let lastOperator:String = operatorStack[operatorStack.count-1]
            if lastOperator == "*" || lastOperator == "/" {
                hendleWhenLastOperatorIsMultiplicationOrDivide(lastOperator: lastOperator)
            }
            if currentOperator == "*" || currentOperator == "/" {
                operatorStack.append(currentOperator)
            }else{
                handleWhenCurrentOperatorIsPlusOrMinus(currentOperator:currentOperator)
            }
        }
        resetValue()
    }
    
    func handleChangeOperatorCaseOne(){
        
    }
    
    func hendleWhenLastOperatorIsMultiplicationOrDivide(lastOperator:String){
        let value1:Double = digitStack.removeLast()
        //removedDigitStack.append(value1)
        let value2:Double = digitStack.removeLast()
        //removedDigitStack.append(value2)
        operatorStack.removeLast()
        if lastOperator == "*" {
            tempResult = value1 * value2
        }else{
            tempResult = value2 / value1
        }
        digitStack.append(tempResult)
        outputResult.text = String(tempResult)
    }
    
    func handleWhenCurrentOperatorIsPlusOrMinus(currentOperator:String){
        if digitStack.count < 2 {
            operatorStack.append(currentOperator)
        }else {
            lastOperator = operatorStack[operatorStack.count-1]
            let value1:Double = digitStack.removeLast()
            removedDigitStack.append(value1)
            let value2:Double = digitStack.removeLast()
            removedDigitStack.append(value2)
            
            if(lastOperator == "+"){
                tempResult = value1 + value2
            }else{
                tempResult = value2 - value1
            }
            let removedOperator = operatorStack.removeLast()
            removedOperatorStack.append(removedOperator)
            
            digitStack.append(tempResult)
            operatorStack.append(currentOperator)
            outputResult.text = String(tempResult)
        }
    }
    
    func resetValue(){
        hasFinishedInput = true
        decimalFactor = 10
        integerValue = 0
        decimalValue = 0
        shouldCalculateDecimalValue = false
    }
    
    @IBAction func resetButton_Click(_ sender: RoundButton) {
        
    }
}

