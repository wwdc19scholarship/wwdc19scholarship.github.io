//
//  ViewController.swift
//  DrawVC
//
//  Created by scauos on 2019/3/19.
//  Copyright © 2019 scauos. All rights reserved.
//

import UIKit
import PlaygroundSupport

class ViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    var displayLink: CADisplayLink? = nil
    
    var timerLabel: UILabel!
    
    var animationDuration: CFTimeInterval = 5.0
    
    var pointColor: UIColor = .red
    
    /// 只有一个控制点的贝塞尔曲线
    var oneView: UIView!
    
    /// 顶层layer
    var oneAnimationLayer: CALayer = CALayer()
    
    
    /// 起点。控制点。终点
    var oneStartPosition: CGPoint = CGPoint(x: 60, y: 50)
    var oneEndPosition: CGPoint = CGPoint(x: 300, y: 50)
    var oneControlPosition: CGPoint = CGPoint(x: 100, y: 170)
    
    
    /// 圆形图
    var oneStartPoint: UIView = UIView()
    var oneEndPoint: UIView = UIView()
    var oneControlPoint: UIView = UIView()
    
    
    /// 曲线
    var oneBezierPath: UIBezierPath!
    
    /// 曲线动画
    var oneBezierLayer: CAShapeLayer = {
        let oneBezierLayer = CAShapeLayer()
        oneBezierLayer.isGeometryFlipped = true
        oneBezierLayer.strokeColor = UIColor.red.cgColor
        oneBezierLayer.fillColor = nil
        oneBezierLayer.lineWidth = 3
        oneBezierLayer.lineJoin = .round
        oneBezierLayer.lineCap = .round
        return oneBezierLayer
    }()
    
    /// 移动点
    var oneMovePointLayer: CAShapeLayer = {
        let caLayer = CAShapeLayer()
        caLayer.frame = CGRect(x: -4, y: -4, width: 8, height: 8)
        caLayer.cornerRadius = 4
        caLayer.masksToBounds = true
        caLayer.backgroundColor = UIColor.blue.cgColor
        return caLayer
    }()
    
    /// 控制线
    var p0p1p2: UIBezierPath!
    
    /// 控制线动画
    var p0p1p2Layer: CAShapeLayer = {
        let p0p1p2Layer = CAShapeLayer()
        p0p1p2Layer.isGeometryFlipped = true
        p0p1p2Layer.strokeColor = UIColor.red.cgColor
        p0p1p2Layer.lineWidth = 2
        p0p1p2Layer.lineJoin = .round
        p0p1p2Layer.lineCap = .round
        p0p1p2Layer.fillColor = nil
        p0p1p2Layer.lineDashPattern = [2,5]
        return p0p1p2Layer
    }()
    
    
    /// 动画的直线
    lazy var oneLineLayer: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.isGeometryFlipped = true
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        return lineLayer
    }()
    
    
    /// 两个控制点的贝塞尔曲线
    var secondView: UIView!
    /// 顶层layer
    var twoAnimationLayer: CALayer = CALayer()
    
    
    /// 起点。控制点。终点
    var twoStartPosition: CGPoint = CGPoint(x: 60, y: 50)
    var twoEndPosition: CGPoint = CGPoint(x: 400, y: 20)
    var twoControlPosition: CGPoint = CGPoint(x: 50, y: 200)
    var twoControlPosition2: CGPoint = CGPoint(x: 300, y: 200)
    
    
    /// 圆形图
    var twoStartPoint: UIView = UIView()
    var twoEndPoint: UIView = UIView()
    var twoControlPoint: UIView = UIView()
    var twoControlPoint2: UIView = UIView()
    
    
    /// 曲线
    var twoBezierPath: UIBezierPath!
    
    /// 曲线动画
    var twoBezierLayer: CAShapeLayer = {
        let twoBezierLayer = CAShapeLayer()
        twoBezierLayer.isGeometryFlipped = true
        twoBezierLayer.strokeColor = UIColor.red.cgColor
        twoBezierLayer.fillColor = nil
        twoBezierLayer.lineWidth = 3
        twoBezierLayer.lineJoin = .round
        twoBezierLayer.lineCap = .round
        return twoBezierLayer
    }()
    
    /// 移动点
    var twoMovePointLayer: CALayer = {
        let caLayer = CALayer()
        caLayer.frame = CGRect(x: -4, y: -4, width: 8, height: 8)
        caLayer.cornerRadius = 4
        caLayer.masksToBounds = true
        caLayer.backgroundColor = UIColor.blue.cgColor
        return caLayer
    }()
    
    /// 控制线
    var p0p1p2p3: UIBezierPath!
    
    /// 控制线动画
    var p0p1p2p3Layer: CAShapeLayer = {
        let p0p1p2p3Layer = CAShapeLayer()
        p0p1p2p3Layer.isGeometryFlipped = true
        p0p1p2p3Layer.strokeColor = UIColor.red.cgColor
        p0p1p2p3Layer.lineWidth = 2
        p0p1p2p3Layer.lineJoin = .round
        p0p1p2p3Layer.lineCap = .round
        p0p1p2p3Layer.fillColor = nil
        p0p1p2p3Layer.lineDashPattern = [2,5]
        return p0p1p2p3Layer
    }()
    
    
    /// 动画的直线
    var twoLineLayer1: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.isGeometryFlipped = true
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        return lineLayer
    }()
    
    var twoLineLayer2: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.isGeometryFlipped = true
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        return lineLayer
    }()
    
    var twoLineLayer3: CAShapeLayer = {
        let lineLayer = CAShapeLayer()
        lineLayer.isGeometryFlipped = true
        lineLayer.strokeColor = UIColor.blue.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        return lineLayer
    }()
    
    /// 线性贝塞尔曲线
    var thirdView: UIView!
    
    /// 顶层layer
    var threeAnimationLayer: CALayer = CALayer()
    
    
    /// 起点，终点
    var threeStartPosition: CGPoint = CGPoint(x: 60, y: 200)
    var threeEndPosition: CGPoint = CGPoint(x: 200, y: 60)
    
    
    /// 圆形图
    var threeStartPoint: UIView = UIView()
    var threeEndPoint: UIView = UIView()
    
    
    /// 曲线
    var threeBezierPath: UIBezierPath!
    
    /// 曲线动画
    var threeBezierLayer: CAShapeLayer = {
        let threeBezierLayer = CAShapeLayer()
        threeBezierLayer.isGeometryFlipped = true
        threeBezierLayer.strokeColor = UIColor.red.cgColor
        threeBezierLayer.fillColor = nil
        threeBezierLayer.lineWidth = 3
        threeBezierLayer.lineJoin = .round
        threeBezierLayer.lineCap = .round
        return threeBezierLayer
    }()
    
    /// 移动点
    var threeMovePointLayer: CAShapeLayer = {
        let caLayer = CAShapeLayer()
        caLayer.frame = CGRect(x: -4, y: -4, width: 8, height: 8)
        caLayer.cornerRadius = 4
        caLayer.masksToBounds = true
        caLayer.backgroundColor = UIColor.blue.cgColor
        return caLayer
    }()
    
    /// 控制线
    var p0p1: UIBezierPath!
    
    /// 控制线动画
    var p0p1Layer: CAShapeLayer = {
        let p0p1Layer = CAShapeLayer()
        p0p1Layer.isGeometryFlipped = true
        p0p1Layer.strokeColor = UIColor.red.cgColor
        p0p1Layer.lineWidth = 2
        p0p1Layer.lineJoin = .round
        p0p1Layer.lineCap = .round
        p0p1Layer.fillColor = nil
        p0p1Layer.lineDashPattern = [2,5]
        return p0p1Layer
    }()
    
    //点击第几个View：1，2，3
    var touchViewIndex = 0
    
    func createPointView(pointView: inout UIView, withPosition position: inout CGPoint, inView view: UIView) {
        pointView.removeFromSuperview()
        pointView = ControlView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        if view.frame.height > 0 {
            position.x = CGFloat.minimum(view.frame.width - 50, position.x)
        }
        pointView.center = CGPoint(x: position.x, y: view.frame.height - position.y)
        pointView.backgroundColor = pointColor
        pointView.layer.cornerRadius = pointView.frame.width / 2
        pointView.layer.masksToBounds = true
        view.addSubview(pointView)
    }
    
    
    func setupView() {
        // 直线面
        thirdView = UIView()
        view.addSubview(thirdView)
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor).isActive = true
        thirdView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        thirdView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        thirdView.heightAnchor.constraint(equalTo: liveViewSafeAreaGuide.heightAnchor, multiplier: 1/3).isActive = true
        
        // 一个控制点 面
        oneView = UIView()
        view.addSubview(oneView)
        oneView.translatesAutoresizingMaskIntoConstraints = false
        oneView.topAnchor.constraint(equalTo: thirdView.bottomAnchor).isActive = true
        oneView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        oneView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        oneView.heightAnchor.constraint(equalTo: liveViewSafeAreaGuide.heightAnchor, multiplier: 1/3).isActive = true
        
        // 两个控制点 面
        secondView = UIView()
        view.addSubview(secondView)
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.topAnchor.constraint(equalTo: oneView.bottomAnchor).isActive = true
        secondView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        secondView.heightAnchor.constraint(equalTo: liveViewSafeAreaGuide.heightAnchor, multiplier: 1/3).isActive = true
        secondView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor).isActive = true
        
        timerLabel = UILabel()
        timerLabel.text = "0.00"
        timerLabel.textColor = .red
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualView)
        visualView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20).isActive = true
        visualView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor, constant: -20).isActive = true
        visualView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        visualView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        visualView.layer.masksToBounds = true
        visualView.layer.cornerRadius = 30
        
        visualView.contentView.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.centerXAnchor.constraint(equalTo: visualView.contentView.centerXAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: visualView.contentView.centerYAnchor).isActive = true
        
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    /// 绘制控制点
    func setupPointView() {
        
        createPointView(pointView: &threeStartPoint, withPosition: &threeStartPosition, inView: thirdView)
        createPointView(pointView: &threeEndPoint, withPosition: &threeEndPosition, inView: thirdView)
        
        createPointView(pointView: &oneStartPoint, withPosition: &oneStartPosition, inView: oneView)
        createPointView(pointView: &oneControlPoint, withPosition: &oneControlPosition, inView: oneView)
        createPointView(pointView: &oneEndPoint, withPosition: &oneEndPosition, inView: oneView)
        
        createPointView(pointView: &twoStartPoint, withPosition: &twoStartPosition, inView: secondView)
        createPointView(pointView: &twoControlPoint, withPosition: &twoControlPosition, inView: secondView)
        createPointView(pointView: &twoControlPoint2, withPosition: &twoControlPosition2, inView: secondView)
        createPointView(pointView: &twoEndPoint, withPosition: &twoEndPosition, inView: secondView)
        
    }
    
    func setupAnimationLayer() {
        self.oneAnimationLayer.removeLayerAndAnimation()
        self.oneAnimationLayer.frame = oneView.bounds
        self.oneView.layer.addSublayer(self.oneAnimationLayer)
        
        self.twoAnimationLayer.removeLayerAndAnimation()
        self.twoAnimationLayer.frame = secondView.bounds
        self.secondView.layer.addSublayer(self.twoAnimationLayer)
        
        self.threeAnimationLayer.removeLayerAndAnimation()
        self.threeAnimationLayer.frame = thirdView.bounds
        self.thirdView.layer.addSublayer(self.threeAnimationLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(showNextPage), userInfo: nil, repeats: false)
    }
    
    override func viewWillLayoutSubviews() {
        
        
    }
    
    override func viewDidLayoutSubviews() {
        setupAnimationLayer()
        setupPointView()
        setupDrawingLayer()
    }
    
    @objc func showNextPage() {
        let Dict: PlaygroundValue = .dictionary(["success": PlaygroundValue.boolean(true)])
        send(Dict)
    }
    
    
    func setupDrawingLayer() {
        displayLink?.invalidate()
        displayLink = nil
        //绘制曲线
        
        oneBezierPath = UIBezierPath()
        oneBezierPath.move(to: oneStartPosition)
        oneBezierPath.addQuadCurve(to: oneEndPosition, controlPoint: oneControlPosition)
        
        oneBezierLayer.frame = self.oneAnimationLayer.bounds
        oneBezierLayer.path = oneBezierPath.cgPath
        
        //绘制虚线
        p0p1p2 = UIBezierPath()
        p0p1p2.move(to: oneStartPosition)
        p0p1p2.addLine(to: oneControlPosition)
        p0p1p2.addLine(to: oneEndPosition)
        
        p0p1p2Layer.frame = self.oneAnimationLayer.bounds
        p0p1p2Layer.path = p0p1p2.cgPath
        
        self.oneAnimationLayer.addSublayer(p0p1p2Layer)
        self.oneAnimationLayer.addSublayer(oneBezierLayer)
        
        //绘制曲线
        twoBezierPath = UIBezierPath()
        twoBezierPath.move(to: twoStartPosition)
        twoBezierPath.addCurve(to: twoEndPosition, controlPoint1: twoControlPosition, controlPoint2: twoControlPosition2)
        
        twoBezierLayer.frame = self.twoAnimationLayer.bounds
        twoBezierLayer.path = twoBezierPath.cgPath
        
        //绘制虚线
        p0p1p2p3 = UIBezierPath()
        p0p1p2p3.move(to: twoStartPosition)
        p0p1p2p3.addLine(to: twoControlPosition)
        p0p1p2p3.addLine(to: twoControlPosition2)
        p0p1p2p3.addLine(to: twoEndPosition)
        
        p0p1p2p3Layer.frame = self.twoAnimationLayer.bounds
        p0p1p2p3Layer.path = p0p1p2p3.cgPath
        
        self.twoAnimationLayer.addSublayer(p0p1p2p3Layer)
        self.twoAnimationLayer.addSublayer(twoBezierLayer)
        
        //绘制曲线
        threeBezierPath = UIBezierPath()
        threeBezierPath.move(to: threeStartPosition)
        threeBezierPath.addLine(to: threeEndPosition)
        
        threeBezierLayer.frame = self.threeAnimationLayer.bounds
        threeBezierLayer.path = threeBezierPath.cgPath
        
        // 绘制虚线
        p0p1 = UIBezierPath()
        p0p1.move(to: threeStartPosition)
        p0p1.addLine(to: threeEndPosition)
        
        p0p1Layer.frame = self.threeAnimationLayer.bounds
        p0p1Layer.path = p0p1.cgPath
        
        self.threeAnimationLayer.addSublayer(p0p1Layer)
        self.threeAnimationLayer.addSublayer(threeBezierLayer)
    }
    
    
    func animateDrawingLayer() {

        let pathAnimation3 = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation3.duration = animationDuration
        pathAnimation3.fromValue = 0.0
        pathAnimation3.toValue = 1.0
        self.threeAnimationLayer.addSublayer(self.threeBezierLayer)
        self.threeBezierLayer.add(pathAnimation3, forKey: "strokeEnd")
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: threeStartPosition.x, y: thirdView.bounds.height-threeStartPosition.y))
        path3.addLine(to: CGPoint(x: threeEndPosition.x, y: thirdView.bounds.height-threeEndPosition.y))
        let movePointAnimation3 = CAKeyframeAnimation(keyPath: "position")
        movePointAnimation3.path = path3.cgPath
        movePointAnimation3.duration = animationDuration
        movePointAnimation3.completion = { finished in
            if finished { self.threeMovePointLayer.removeFromSuperlayer() }
        }
        
        self.threeAnimationLayer.addSublayer(self.threeMovePointLayer)
        threeMovePointLayer.add(movePointAnimation3, forKey: nil)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = animationDuration
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        oneLineLayer.frame = oneAnimationLayer.bounds
        self.oneBezierLayer.add(pathAnimation, forKey: "strokeEnd")
        self.oneAnimationLayer.addSublayer(self.oneBezierLayer)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: oneStartPosition.x, y: oneView.bounds.height-oneStartPosition.y))
        path.addQuadCurve(to: CGPoint(x: oneEndPosition.x, y: oneView.bounds.height-oneEndPosition.y), controlPoint: CGPoint(x: oneControlPosition.x, y: oneView.frame.height-oneControlPosition.y))
        let movePointAnimation = CAKeyframeAnimation(keyPath: "position")
        movePointAnimation.path = path.cgPath
        movePointAnimation.duration = animationDuration
        movePointAnimation.completion = { finished in
            if finished { self.oneMovePointLayer.removeFromSuperlayer() }
        }
        self.oneAnimationLayer.addSublayer(self.oneMovePointLayer)
        oneMovePointLayer.add(movePointAnimation, forKey: nil)
        
        let line = UIBezierPath()
        line.move(to: oneStartPosition)
        line.addLine(to: oneControlPosition)
        
        let endLine = UIBezierPath()
        endLine.move(to: oneControlPosition)
        endLine.addLine(to: oneEndPosition)
        
        oneLineLayer.path = endLine.cgPath
        
        self.oneAnimationLayer.addSublayer(oneLineLayer)
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = line.cgPath
        animation.toValue = endLine.cgPath
        animation.duration = animationDuration
        oneLineLayer.add(animation, forKey: "path")
        
        
        let twoPathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        twoPathAnimation.duration = animationDuration
        twoPathAnimation.fromValue = 0.0
        twoPathAnimation.toValue = 1.0
        self.twoBezierLayer.add(twoPathAnimation, forKey: nil)
        self.twoAnimationLayer.addSublayer(self.twoBezierLayer)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: twoStartPosition.x, y: secondView.bounds.height-twoStartPosition.y))
        path2.addCurve(to: CGPoint(x: twoEndPosition.x, y: secondView.bounds.height-twoEndPosition.y), controlPoint1: CGPoint(x: twoControlPosition.x, y: secondView.bounds.height-twoControlPosition.y), controlPoint2: CGPoint(x: twoControlPosition2.x, y: secondView.bounds.height-twoControlPosition2.y))
        
        let movePointAnimation2 = CAKeyframeAnimation(keyPath: "position")
        movePointAnimation2.path = path2.cgPath
        movePointAnimation2.duration = animationDuration
        movePointAnimation2.completion = { finished in
            if finished { self.twoMovePointLayer.removeFromSuperlayer() }
        }
        twoAnimationLayer.addSublayer(twoMovePointLayer)
        twoMovePointLayer.add(movePointAnimation2, forKey: nil)
        
        
        let line1 = UIBezierPath()
        line1.move(to: twoStartPosition)
        line1.addLine(to: twoControlPosition)
        
        let endLine1 = UIBezierPath()
        endLine1.move(to: twoControlPosition)
        endLine1.addLine(to: twoControlPosition2)
        
        let line2 = UIBezierPath()
        line2.move(to: twoControlPosition)
        line2.addLine(to: twoControlPosition2)
        
        let endLine2 = UIBezierPath()
        endLine2.move(to: twoControlPosition2)
        endLine2.addLine(to: twoEndPosition)
        
        let line3 = UIBezierPath()
        line3.move(to: twoStartPosition)
        line3.addLine(to: twoControlPosition)
        
        let endLine3 = UIBezierPath()
        endLine3.move(to: twoControlPosition2)
        endLine3.addLine(to: twoEndPosition)
        
        twoLineLayer1.path = endLine1.cgPath
        twoLineLayer2.path = endLine2.cgPath
        //twoLineLayer3.path = endLine3.cgPath
        
        twoLineLayer1.frame = self.twoAnimationLayer.bounds
        twoLineLayer2.frame = self.twoAnimationLayer.bounds
        twoLineLayer3.frame = twoAnimationLayer.bounds
        self.twoAnimationLayer.addSublayer(twoLineLayer1)
        self.twoAnimationLayer.addSublayer(twoLineLayer2)
        
        let animation1 = CABasicAnimation(keyPath: "path")
        animation1.fromValue = line1.cgPath
        animation1.toValue = endLine1.cgPath
        animation1.duration = animationDuration
        twoLineLayer1.add(animation1, forKey: nil)
        
        let animation2 = CABasicAnimation(keyPath: "path")
        animation2.fromValue = line2.cgPath
        animation2.toValue = endLine2.cgPath
        animation2.duration = animationDuration
        twoLineLayer2.add(animation2, forKey: nil)
        
        
        displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate(_:)))
        displayLink!.add(to: RunLoop.main, forMode: .default)
    }
    
    @objc func animationDidUpdate(_ displayLink: CADisplayLink) {
        let presentationLayer: CAShapeLayer = oneBezierLayer.presentation()!
        let t = presentationLayer.strokeEnd
        var point1 = CGPoint()
        var point2 = CGPoint()
        var point3 = CGPoint()
        point1.x = (1-t)*(1-t)*twoStartPosition.x + 2*t*(1-t)*twoControlPosition.x + t*t*twoControlPosition2.x
        point1.y = (1-t)*(1-t)*twoStartPosition.y + 2*t*(1-t)*twoControlPosition.y + t*t*twoControlPosition2.y
        point2.x = (1-t)*(1-t)*twoControlPosition.x + 2*t*(1-t)*twoControlPosition2.x + t*t*twoEndPosition.x
        point2.y = (1-t)*(1-t)*twoControlPosition.y + 2*t*(1-t)*twoControlPosition2.y + t*t*twoEndPosition.y
        point3.x = (1-t)*(1-t)*(1-t)*twoStartPosition.x + 3*t*(1-t)*(1-t)*twoControlPosition.x + t*t*twoControlPosition2.x*(1-t)*3 + twoEndPosition.x*t*t*t
        point3.y = (1-t)*(1-t)*(1-t)*twoStartPosition.y + 3*t*(1-t)*(1-t)*twoControlPosition.y + t*t*twoControlPosition2.y*(1-t)*3 + twoEndPosition.y*t*t*t
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        
        twoLineLayer3.removeFromSuperlayer()
        twoLineLayer3.path = path.cgPath
        twoLineLayer3.strokeColor = UIColor.brown.cgColor
        self.twoAnimationLayer.addSublayer(twoLineLayer3)
        
        DispatchQueue.main.async {
            self.timerLabel.text = String(format: "%.2f", t)
        }
        
        if t == 1.0 {
            self.displayLink?.invalidate()
            self.displayLink = nil
            self.twoLineLayer3.removeFromSuperlayer()
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchView = touches.first!.view
        if touchView === oneStartPoint ||
            touchView === oneControlPoint ||
            touchView === oneEndPoint {
            touchViewIndex = 1
            self.oneBezierLayer.removeAllAnimations()
            self.oneLineLayer.removeAllAnimations()
            self.oneLineLayer.removeFromSuperlayer()
            self.oneMovePointLayer.removeFromSuperlayer()
            self.oneMovePointLayer.removeAllAnimations()
        } else if touchView === twoStartPoint ||
            touchView === twoControlPoint ||
            touchView === twoControlPoint2 ||
            touchView === twoEndPoint {
            touchViewIndex = 2
            self.twoBezierLayer.removeAllAnimations()
            self.twoBezierLayer.removeFromSuperlayer()
            self.twoLineLayer1.removeAllAnimations()
            self.twoLineLayer1.removeFromSuperlayer()
            self.twoLineLayer2.removeFromSuperlayer()
            self.twoLineLayer2.removeAllAnimations()
            self.twoLineLayer3.removeAllAnimations()
            self.twoLineLayer3.removeFromSuperlayer()
            self.twoMovePointLayer.removeAllAnimations()
            self.twoMovePointLayer.removeFromSuperlayer()
        } else if touchView === threeStartPoint ||
                touchView === threeEndPoint {
            touchViewIndex = 3
            self.threeBezierLayer.removeAllAnimations()
            self.threeBezierLayer.removeFromSuperlayer()
            self.threeMovePointLayer.removeFromSuperlayer()
            self.threeMovePointLayer.removeAllAnimations()
        } else { return }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var position: CGPoint!
        var layerPosition: CGPoint!
        if touchViewIndex == 1 {
            position = touches.first!.location(in: self.oneView)
            position.x = CGFloat.minimum(oneView.frame.width, position.x)
            position.x = CGFloat.maximum(0, position.x)
            position.y = CGFloat.minimum(position.y, oneView.frame.height)
            position.y = CGFloat.maximum(0, position.y)
            layerPosition = CGPoint(x: position.x, y: oneView.frame.height - position.y)
        } else if touchViewIndex == 2 {
            position = touches.first!.location(in: self.secondView)
            position.x = CGFloat.minimum(secondView.frame.width, position.x)
            position.x = CGFloat.maximum(0, position.x)
            position.y = CGFloat.minimum(position.y, secondView.frame.height)
            position.y = CGFloat.maximum(0, position.y)
            layerPosition = CGPoint(x: position.x, y: secondView.frame.height - position.y)
        } else if touchViewIndex == 3 {
            position = touches.first!.location(in: self.thirdView)
            position.x = CGFloat.minimum(thirdView.frame.width, position.x)
            position.x = CGFloat.maximum(0, position.x)
            position.y = CGFloat.minimum(position.y, thirdView.frame.height)
            position.y = CGFloat.maximum(0, position.y)
            layerPosition = CGPoint(x: position.x, y: thirdView.frame.height - position.y)
        } else { return }
        if touches.first?.view === oneStartPoint {
            oneStartPoint.center = position
            updateBezierPath(startPoint: layerPosition, controlPoint: self.oneControlPosition, endPoint: self.oneEndPosition)
        } else if touches.first!.view === oneControlPoint {
            oneControlPoint.center = position
            updateBezierPath(startPoint: self.oneStartPosition, controlPoint: layerPosition, endPoint: self.oneEndPosition)
        } else if touches.first!.view === oneEndPoint {
            oneEndPoint.center = position
            updateBezierPath(startPoint: self.oneStartPosition, controlPoint: self.oneControlPosition, endPoint: layerPosition)
        } else if touches.first!.view === twoStartPoint {
            twoStartPoint.center = position
            updateBezierPath(startPoint: layerPosition, controlPoint: twoControlPosition, controlPoint2: twoControlPosition2, endPoint: twoEndPosition)
        } else if touches.first!.view === twoControlPoint {
            twoControlPoint.center = position
            updateBezierPath(startPoint: twoStartPosition, controlPoint: layerPosition, controlPoint2: twoControlPosition2, endPoint: twoEndPosition)
        } else if touches.first!.view === twoControlPoint2 {
            twoControlPoint2.center = position
            updateBezierPath(startPoint: twoStartPosition, controlPoint: twoControlPosition, controlPoint2: layerPosition, endPoint: twoEndPosition)
        } else if touches.first!.view === twoEndPoint {
            twoEndPoint.center = position
            updateBezierPath(startPoint: twoStartPosition, controlPoint: twoControlPosition, controlPoint2: twoControlPosition2, endPoint: layerPosition)
        } else if touches.first!.view === threeStartPoint {
            threeStartPoint.center = position
            updateLinearPath(startPoint: layerPosition, endPoint: threeEndPosition)
        } else if touches.first!.view === threeEndPoint {
            threeEndPoint.center = position
            updateLinearPath(startPoint: threeStartPosition, endPoint: layerPosition)
        } else { return }
    }
    
    func updateLinearPath(startPoint p0: CGPoint, endPoint p1: CGPoint) {
        threeBezierPath.removeAllPoints()
        threeBezierLayer.removeFromSuperlayer()
        threeBezierLayer.removeAllAnimations()
        threeBezierPath.move(to: p0)
        threeBezierPath.addLine(to: p1)
        threeBezierLayer.path = threeBezierPath.cgPath
        self.threeAnimationLayer.addSublayer(threeBezierLayer)
        self.threeStartPosition = p0
        self.threeEndPosition = p1
        
        p0p1.removeAllPoints()
        p0p1Layer.removeFromSuperlayer()
        p0p1.move(to: threeStartPosition)
        p0p1.addLine(to: threeEndPosition)
        
        p0p1Layer.path = p0p1.cgPath
        self.threeAnimationLayer.addSublayer(p0p1Layer)
    }
    
    func updateBezierPath(startPoint p0: CGPoint, controlPoint p1: CGPoint, endPoint p2: CGPoint) {
        oneBezierPath.removeAllPoints()
        oneBezierLayer.removeFromSuperlayer()
        oneBezierPath.move(to: p0)
        oneBezierPath.addQuadCurve(to: p2, controlPoint: p1)
        oneBezierLayer.path = oneBezierPath.cgPath
        self.oneAnimationLayer.addSublayer(oneBezierLayer)
        self.oneStartPosition = p0
        self.oneControlPosition = p1
        self.oneEndPosition = p2
        
        //更新虚线
        p0p1p2.removeAllPoints()
        p0p1p2Layer.removeFromSuperlayer()
        p0p1p2.move(to: oneStartPosition)
        p0p1p2.addLine(to: oneControlPosition)
        p0p1p2.addLine(to: oneEndPosition)
        
        p0p1p2Layer.path = p0p1p2.cgPath
        self.oneAnimationLayer.addSublayer(p0p1p2Layer)
    }
    
    func updateBezierPath(startPoint p0: CGPoint, controlPoint p1: CGPoint, controlPoint2 p2: CGPoint, endPoint p3: CGPoint) {
        twoBezierPath.removeAllPoints()
        twoBezierLayer.removeFromSuperlayer()
        twoBezierPath.move(to: p0)
        twoBezierPath.addCurve(to: p3, controlPoint1: p1, controlPoint2: p2)
        twoBezierLayer.path = twoBezierPath.cgPath
        self.twoAnimationLayer.addSublayer(twoBezierLayer)
        self.twoStartPosition = p0
        self.twoControlPosition = p1
        self.twoControlPosition2 = p2
        self.twoEndPosition = p3
        
        //更新虚线
        p0p1p2p3.removeAllPoints()
        p0p1p2p3Layer.removeFromSuperlayer()
        p0p1p2p3.move(to: twoStartPosition)
        p0p1p2p3.addLine(to: twoControlPosition)
        p0p1p2p3.addLine(to: twoControlPosition2)
        p0p1p2p3.addLine(to: twoEndPosition)
        
        p0p1p2p3Layer.path = p0p1p2p3.cgPath
        self.twoAnimationLayer.addSublayer(p0p1p2p3Layer)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchViewIndex != 0 else { return }
        touchViewIndex = 0
        self.animateDrawingLayer()
    }
}

extension ViewController: PlaygroundLiveViewMessageHandler {
    func receive(_ message: PlaygroundValue) {
        switch message {
        case .string(let str):
            if str == "hello" {
                self.view.backgroundColor = UIColor.blue
            }
        case .dictionary(let dir):
            if case let .floatingPoint(value)? = dir["animationDuration"] {
                self.animationDuration = 5.0 / value
            } else if case let .data(value)? = dir["pointColor"] {
                let color = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: value)
                guard color != nil else { return }
                self.pointColor = color!
                self.setupPointView()
            }
        default:
            break
        }
    }
}

