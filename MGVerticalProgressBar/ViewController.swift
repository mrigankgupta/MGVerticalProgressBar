//
//  ViewController.swift
//  MGVerticalProgressBar
//
//  Created by Gupta, Mrigank on 14/08/17.
//  MIT License
//  Copyright (c) 2017 Mrigank
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

import UIKit

class ViewController: UIViewController {
    var timer: Timer?
    @IBOutlet weak var pBar1: MGVerticalProgressBar!
    @IBOutlet weak var pBar2: MGVerticalProgressBar!
    @IBOutlet weak var pBar3: MGVerticalProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var percent:Float = 100.0
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [weak self](timer) in
            var p = self?.getRandomPercent()
            self?.pBar1.progress = p!
            
            p = self?.getRandomPercent()
            self?.pBar2.progress = p!
            
            self?.pBar3.progress = percent/100.0
            print("\(percent)")
            self?.pBar3.percentText = "\(Int(percent))"
            percent = percent >= 10 ? percent-10 : 100
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getRandomPercent()-> Float {
        let percent = arc4random()%100
        let progress = Float(percent)/100.0
        return progress
    }
}

