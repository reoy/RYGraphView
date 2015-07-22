//
//  RYCircleLayer.swift
//  RYGraphView
//
//  Created by Reo Yoshida on 2015/07/17.
//  Copyright (c) 2015年 Reo Yoshida. All rights reserved.
//

import UIKit
import QuartzCore

class RYCircleLayer: CAShapeLayer {
    
    override init!() {
        super.init()
    }
    
    convenience init(center: CGPoint, radius: CGFloat, lineWidth: CGFloat, percentage: CGFloat, strokeColor:UIColor) {
        self.init()
        let can            = CGFloat(M_PI) / 2// Circle adjustment number
        let margin:CGFloat = 2
        let path           = UIBezierPath(arcCenter: center, radius: radius - (margin + lineWidth) , startAngle: -1 * can, endAngle: percentage * 2.0 * CGFloat(M_PI) - can, clockwise: true)
        self.path          = path.CGPath
        self.lineWidth     = lineWidth
        self.lineCap       = kCALineCapRound
        self.fillColor     = UIColor.clearColor().CGColor
        self.strokeColor   = strokeColor.CGColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
