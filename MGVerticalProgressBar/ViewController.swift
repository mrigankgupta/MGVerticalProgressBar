//
//  ViewController.swift
//  MGVerticalProgressBar
//
//  Created by Gupta, Mrigank on 14/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: Timer?
    @IBOutlet weak var pBar1: MGVerticalProgressBar!
    @IBOutlet weak var pBar2: MGVerticalProgressBar!
    @IBOutlet weak var pBar3: MGVerticalProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [weak self](timer) in
            let p = self?.getRandomPercent()
            self?.pBar1.progress = p!
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

