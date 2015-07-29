//
//  RYCircleGraphView.swift
//  RYGraphView
//
//  Created by Reo Yoshida on 2015/07/15.
//  Copyright (c) 2015年 Reo Yoshida. All rights reserved.
//

import UIKit

class RYCircleGraphView: UIView {
    
    private var backgroundStrokeLayer:CAShapeLayer?
    private var strokeLayer:CAShapeLayer?
    private var accomplishLayer:CAShapeLayer?
    
    var backgroundRounded = false {
        didSet {
            if backgroundRounded {
                self.layer.cornerRadius = self.getRadius()
            } else {
                self.layer.cornerRadius = 0
            }
        }
    }
    
    var timerBeganTime:NSDate?
    var animationTimer:NSTimer?
    var animationDuration:CFTimeInterval = 0.5
    var percent:CGFloat = 0 {
        didSet {
            if percent < 0 {
                percent = 0
            } else if percent > 1 {
                percent = 1
            }
        }
    }
    
    private var lineWidth:CGFloat = 3
    private var margin:CGFloat = 2
    private var strokeBackgroundColor = UIColor(red:0.98, green:0.96, blue:0.8, alpha:1)
    private var strokeColor = UIColor(red:1, green:0.67, blue:0.22, alpha:1)
    private var accomplishColor = UIColor(red:0.49, green:0.8, blue:0.32, alpha:1)
    
    private var _customView:UIView?
    var customView:UIView? {
        get {
            if let customView = self._customView {
                return customView
            } else {
                return nil
            }
        }
        set {
            self.percentageLabel?.hidden = true
            self._customView = newValue
        }
    }
    private var percentageLabel:UILabel?
    private var accomplishView:UIView?
    
    // MARK: - Keys
    private let strokeAnimationKey = "StrokeAnimation"
    private let accomplishAnimationKey = "AccomplishAnimation"
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createBackground()
        createLabel()
    }
    
    func draw(#percent: CGFloat) {
        self.percent = percent
        
        strokeLayer?.removeFromSuperlayer()
        strokeLayer = createCircleLayer(percent, strokeColor:strokeColor)
        self.layer.addSublayer(strokeLayer)
    }
    
    func redraw(#percent:CGFloat ,animated: Bool) {
        self.percent = percent
        
        createBackground()
        if animated {
            drawWithAnimation(percent: self.percent)
        } else {
            draw(percent: self.percent)
        }
    }
    
    func  drawWithAnimation(#percent: CGFloat) {
        refreshAllObject()
        
        self.percent = percent
        
        if let customView = customView {
            configureCustomView()
        }
        
        strokeLayer = createCircleLayer(percent, strokeColor:strokeColor)
        self.layer.addSublayer(strokeLayer!)
    
        CATransaction.begin()
        let drawAnim = CABasicAnimation(keyPath:  "strokeEnd")
        drawAnim.delegate = self
        drawAnim.duration = animationDuration
        drawAnim.removedOnCompletion = false
        drawAnim.repeatCount = 1.0
        drawAnim.fromValue = NSNumber(float: 0)
        drawAnim.toValue = NSNumber(float: 1)
        drawAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeLayer?.addAnimation(drawAnim, forKey: strokeAnimationKey)
        CATransaction.commit()
    }
    
    private func refreshAllObject() {
        percentageLabel?.removeFromSuperview()
        strokeLayer?.removeFromSuperlayer()
        accomplishLayer?.removeFromSuperlayer()
        
        createLabel()
    }
    
    private func accomplishAnimation() {
        
        accomplishLayer?.removeFromSuperlayer()
        accomplishLayer = createAccomplishLayer()
        self.layer.addSublayer(accomplishLayer!)
    
        CATransaction.begin()
        let strokeColorAnim = CABasicAnimation(keyPath:  "strokeColor")
        strokeColorAnim.delegate = self
        strokeColorAnim.removedOnCompletion = false
        strokeColorAnim.duration = animationDuration
        strokeColorAnim.fillMode = kCAFillModeForwards
        strokeColorAnim.toValue = accomplishColor.CGColor
        strokeColorAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeLayer?.addAnimation(strokeColorAnim, forKey: accomplishAnimationKey)
        
        let showAccomplishViewAnim = CABasicAnimation(keyPath: "strokeEnd")
        showAccomplishViewAnim.removedOnCompletion = false
        showAccomplishViewAnim.duration = animationDuration
        showAccomplishViewAnim.fillMode = kCAFillModeForwards
        showAccomplishViewAnim.fromValue = 0.0
        showAccomplishViewAnim.toValue = 1.0
        showAccomplishViewAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        accomplishLayer?.addAnimation(showAccomplishViewAnim, forKey: nil)
        CATransaction.commit()

        
        let hidePercentageLabelAnim = CABasicAnimation(keyPath: "opacity")
        hidePercentageLabelAnim.removedOnCompletion = false
        hidePercentageLabelAnim.duration = animationDuration / 2
        hidePercentageLabelAnim.fillMode = kCAFillModeForwards
        hidePercentageLabelAnim.toValue = 0
        hidePercentageLabelAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        percentageLabel?.layer.addAnimation(hidePercentageLabelAnim, forKey: nil)
        CATransaction.commit()
    }
    
    private func configureCustomView() {
        customView!.removeFromSuperview()
        var x = CGFloat(getCenter().x) - ((getRadius() - 6.5) * CGFloat(cos(M_PI / 4.0)))
        var y = CGFloat(getCenter().y) - ((getRadius() - 6.5) * CGFloat(sin(M_PI / 4.0)))
        var sideLength = ((getRadius() - 6.5) * CGFloat(cos(M_PI / 4.0))) * 2
        customView!.frame = CGRectMake(x, y, sideLength, sideLength)
        println(NSStringFromCGRect(customView!.frame))
        self.addSubview(customView!)
    }
    
    private func createAccomplishLayer()->CAShapeLayer {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, self.frame.width * 0.26, self.frame.height * 0.54)
        CGPathAddLineToPoint(path, nil, self.frame.width * 0.43, self.frame.height * 0.68)
        CGPathAddLineToPoint(path, nil, self.frame.width * 0.74, self.frame.height * 0.35)
        
        let layer = CAShapeLayer()
        layer.strokeColor = accomplishColor.CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = lineWidth
        layer.path = path
        return layer
    }
    
    private func createLabel() {
        percentageLabel?.removeFromSuperview()
        percentageLabel = UILabel(frame: self.bounds)
        percentageLabel?.textAlignment = NSTextAlignment.Center
        percentageLabel?.textColor = strokeColor
        percentageLabel?.text = "\(Int(percent*100))%"
        percentageLabel?.font = UIFont(name: "HelveticaNeue", size: getRadius()/2)
        self.addSubview(percentageLabel!)
    }
    
    private func createBackground() {
        backgroundStrokeLayer?.removeFromSuperlayer()
        backgroundStrokeLayer = createCircleLayer(100, strokeColor:strokeBackgroundColor)
        self.layer.addSublayer(backgroundStrokeLayer)
    }
    
    /**
    create circle layer
    
    :param: percent     stroke 0.0 - 1.0
    :param: strokeColor stroke color
    
    :returns: CAShapeLayer
    */
    private func createCircleLayer(percent:CGFloat, strokeColor: UIColor)-> CAShapeLayer {
        let layer:RYCircleLayer = RYCircleLayer(center: getCenter(), radius: getRadius(), lineWidth: lineWidth, percentage: percent, strokeColor: strokeColor)
        return layer
    }
    
    private func getCenter() -> CGPoint {
        return CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
    }
    
    private func getRadius() -> CGFloat {
        return self.frame.size.width > self.frame.size.height ? self.frame.size.height/2 : self.frame.size.width/2
    }
    
    private func updateProgressLabel(progress: Float) {
        percentageLabel?.text = NSString(format: "%.0f%%", progress * 100) as String
    }
    
    func timerCalled(timer:NSTimer) {
        if timerBeganTime == nil {
            timerBeganTime = NSDate()
        } else {
            let interval = abs(timerBeganTime!.timeIntervalSinceNow)
            let progress:Float = (Float(interval) / Float(animationDuration)) * Float(percent)
            updateProgressLabel(progress)
        }
    }
    
    //MARK: - CAAnimationDelegate
    
    override func animationDidStart(anim: CAAnimation!) {
        if anim == strokeLayer?.animationForKey(strokeAnimationKey) {
            animationTimer?.invalidate()
            animationTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "timerCalled:", userInfo: nil, repeats: true)
            animationTimer!.fire()
        } else if anim == strokeLayer?.animationForKey(accomplishAnimationKey) {
            
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if anim == strokeLayer?.animationForKey(strokeAnimationKey) {
            // kill timer
            strokeLayer?.removeAnimationForKey(strokeAnimationKey)
            animationTimer?.invalidate()
            timerBeganTime = nil
            
            // adjust label
            percentageLabel?.text = NSString(format: "%.0f%%", percent * 100) as String
            
            if percent == 1 { accomplishAnimation() }
            
        } else if anim == strokeLayer?.animationForKey(accomplishAnimationKey) {
            strokeLayer?.strokeColor = accomplishColor.CGColor
            strokeLayer?.removeAnimationForKey(accomplishAnimationKey)
        }
    }
}
