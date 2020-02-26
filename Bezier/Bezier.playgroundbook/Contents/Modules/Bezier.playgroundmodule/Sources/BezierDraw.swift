//
//  BezierDrawVC.swift
//  Book_Sources
//
//  Created by scauos on 2019/3/22.
//

import UIKit
enum ObjectType: Int {
    case box
    case triangle
    case circle
    case line
    case curve
    case star
    case swift
    case apple
    case wwdc
}
protocol BezierDrawDelegate: class {
    func runButtonDidClicked(with path: UIBezierPath)
    func updatePlane(with path: UIBezierPath)
    func changeModel(with path: UIBezierPath)
    func changeSpin(with index: Int)
}
class BezierDraw: UIView {
    weak var delegate: BezierDrawDelegate?
    lazy var segmentedControl: UISegmentedControl! = {
        let segment = UISegmentedControl()
        segment.insertSegment(with: UIImage(named: "Box.png"), at: 0, animated: true)
        segment.insertSegment(with: UIImage(named: "triangle.png"), at: 1, animated: true)
        segment.insertSegment(with: UIImage(named: "Circle"), at: 2, animated: true)
        segment.insertSegment(with: UIImage(named: "Line"), at: 3, animated: true)
        segment.insertSegment(with: UIImage(named: "Curved"), at: 4, animated: true)
        segment.insertSegment(with: UIImage(named: "stars"), at: 5, animated: true)
        segment.insertSegment(with: UIImage(named: "Swift"), at: 6, animated: true)
        segment.insertSegment(withTitle: "", at: 7, animated: true)
        //segment.insertSegment(with: UIImage(named: "Apple"), at: 7, animated: true)
        segment.insertSegment(with: UIImage(named: "wwdc"), at: 8, animated: true)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(valueDidChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var segmentedControl2: UISegmentedControl! = {
        let segment = UISegmentedControl()
        segment.insertSegment(with: UIImage(named: "Span1"), at: 0, animated: true)
        segment.insertSegment(with: UIImage(named: "Span2"), at: 1, animated: true)
        segment.insertSegment(with: UIImage(named: "Span3"), at: 2, animated: true)
        segment.selectedSegmentIndex = 2
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(valueDidChanged2(_:)), for: .valueChanged)
        return segment
    }()
    
    lazy var toolbar: UIToolbar! = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.setItems([UIBarButtonItem(customView: segmentedControl),
                          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                          UIBarButtonItem(customView: segmentedControl2),
                          UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play,
                                          target: self,
                                          action: #selector(runButtonTouchHandler))],
                         animated: false)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var drawLayer = CALayer()
    
    var pathLayer: CAShapeLayer! = {
        let pathLayer = CAShapeLayer()
        pathLayer.isGeometryFlipped = true
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 3
        pathLayer.lineJoin = .round
        pathLayer.lineCap = .round
        return pathLayer
    }()
    
    var controlViews: [ControlView] = []
    var controlViewIndex: Int = 0
    var model: ObjectModel = ObjectModel()
    var objectType = ObjectType.box
    
    func setupView() {
        self.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: CGFloat(29 *  segmentedControl.numberOfSegments)).isActive = true
        segmentedControl2.widthAnchor.constraint(equalToConstant: CGFloat(29 *  segmentedControl2.numberOfSegments)).isActive = true
    }
    
    func setupLayer(with type: ObjectType) {
        drawLayer.removeFromSuperlayer()
        drawLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.layer.addSublayer(drawLayer)
        self.createLayer(with: type)
    }
    
    func createLayer(with type: ObjectType) {
        for item in controlViews { item.removeFromSuperview() }
        model = ObjectFectory.createObject(inView: self, frame: self.drawLayer.frame, type: objectType)
        model.type = objectType
        pathLayer.frame = self.drawLayer.frame
        pathLayer.path = model.path.cgPath
        drawLayer.addSublayer(pathLayer)
        controlViews = model.controlViews
    }
    
    func updatePathLayer(withPoint point: CGPoint, index: Int) {
        pathLayer.removeFromSuperlayer()
        controlViews[index].center = point
        
        model.points[index].point = CGPoint(x: point.x, y: self.drawLayer.frame.height - point.y)
        model.path = ObjectFectory.updatePath(for: objectType, for: model.points)
        pathLayer.frame = self.drawLayer.frame
        pathLayer.path = model.path.cgPath
        drawLayer.addSublayer(pathLayer)
    }
    @discardableResult
    func createPointView(withPosition position: CGPoint) -> ControlView {
        let pointView = ControlView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        pointView.center = CGPoint(x: position.x, y: self.drawLayer.frame.height - position.y)
        pointView.backgroundColor = .red
        pointView.layer.cornerRadius = pointView.frame.width / 2
        pointView.layer.masksToBounds = true
        self.addSubview(pointView)
        return pointView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc func valueDidChanged(_ sender: UISegmentedControl) {
        objectType = ObjectType(rawValue: sender.selectedSegmentIndex)!
        model.type = objectType
        createLayer(with: objectType)
        self.delegate?.changeModel(with: ObjectFectory.generatePath(self.model))
    }
    
    @objc func valueDidChanged2(_ sender: UISegmentedControl) {
        self.delegate?.changeSpin(with: sender.selectedSegmentIndex)
    }
    
    @objc func runButtonTouchHandler(_ sender: UIBarButtonItem) {
        self.delegate?.runButtonDidClicked(with: ObjectFectory.generatePath(self.model))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = touches.first?.view else { return }
        if touchView === self { return }
        for i in 0 ..< controlViews.count {
            if touchView === controlViews[i] {
                controlViewIndex = i
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchView = touches.first?.view, var point = touches.first?.location(in: self) else { return }
        if touchView === self { return }
        print(point)
        point.y = CGFloat.minimum(self.drawLayer.frame.height, point.y)
        point.y = CGFloat.maximum(point.y, 0)
        updatePathLayer(withPoint: point, index: controlViewIndex)
        if objectType == .box {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.updatePlane(with: ObjectFectory.generatePath(self.model))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

}
