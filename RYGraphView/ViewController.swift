//
//  ViewController.swift
//  RYGraphView
//
//  Created by Reo Yoshida on 2015/07/15.
//  Copyright (c) 2015年 Reo Yoshida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleGraph: RYCircleGraphView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
//        circleGraph.draw(percent: 0.3)
        circleGraph.backgroundRounded = true
        let percent:CGFloat = CGFloat(NSString(string: textField.text).floatValue) / 100.0
        circleGraph.drawWithAnimation(percent: percent)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSelected () {
        let percent:CGFloat = CGFloat(NSString(string: textField.text).floatValue) / 100.0
        circleGraph.redraw(percent: percent, animated: true)
    }

}

