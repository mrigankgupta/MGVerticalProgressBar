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
    @IBOutlet weak var pbar2: MGVerticalProgressBar!
    @IBOutlet weak var pBar3: MGVerticalProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pBar1.trackImage = UIImage(named: "trackImage")
        pBar1.cornerRadius = 1.0
        pBar1.insetX = 3
        pBar1.insetY = 3
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            let percent = arc4random()%100
            let progress = Float(percent)/100.0
            self.pBar1.progress = Float(progress)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

