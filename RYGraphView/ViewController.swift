//
//  ViewController.swift
//  RYGraphView
//
//  Created by Reo Yoshida on 2015/07/15.
//  Copyright (c) 2015年 Reo Yoshida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleGraph: RYCircleGraphView! {
        didSet {
            circleGraph.backgroundRounded = true
        }
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        draw()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSelected () {
        draw()
    }
    
    @IBAction func sliderAction() {
        label.text = "\(Int(round(slider.value * 100)))%"
    }
    
    func draw() {
        let percent:CGFloat = CGFloat(slider.value)
        circleGraph.drawWithAnimation(percent: percent)
    }
}

