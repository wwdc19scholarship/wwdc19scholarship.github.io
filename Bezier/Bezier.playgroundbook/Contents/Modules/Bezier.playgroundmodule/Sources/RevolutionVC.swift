/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of iOS view controller that demonstrates differetent quaternion use cases.
*/

import UIKit
import simd
import SceneKit

import PlaygroundSupport



class RevolutionVC: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    lazy var sceneKitView: SCNView! = {
        let sceneView = SCNView(frame: self.view.frame)
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.allowsTranslation = true
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = false
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    var path: UIBezierPath!
    
    lazy var drawView: BezierDraw! = {
       let drawView = BezierDraw(frame: .zero)
        drawView.translatesAutoresizingMaskIntoConstraints = false
        return drawView
    }()
    
    //是否已经旋转成面
    var hadTranslate = false
    
    var pathNode: SCNNode = SCNNode()
    
    let defaultColor = UIColor.orange

    lazy var scene = setupSceneKit()
    
    var model: ObjectModel!
    
    var spanIndex: Int = 0 {
        didSet {
            if drawView.segmentedControl2.selectedSegmentIndex == 0 {
                if self.drawView.objectType == .wwdc {
                    origin = simd_float3(0, 0, -0.75)
                } else {
                    origin = simd_float3(0, 0, -0.5)
                }
            } else if drawView.segmentedControl2.selectedSegmentIndex == 1 {
                origin = simd_float3(0, 0, 0)
            } else {
                if self.drawView.objectType == .wwdc {
                    origin = simd_float3(0, 0, 0.5)
                } else {
                    origin = simd_float3(0, 0, 1)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneKitView)
        sceneKitView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        sceneKitView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor).isActive = true
        sceneKitView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        sceneKitView.heightAnchor.constraint(equalTo: liveViewSafeAreaGuide.heightAnchor, multiplier: 1/2).isActive = true
        view.addSubview(drawView)
        drawView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        drawView.topAnchor.constraint(equalTo: sceneKitView.bottomAnchor).isActive = true
        drawView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        drawView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor).isActive = true
        drawView.delegate = self
        
        scene = setupSceneKit()
        isRunning = false
        displaylink?.invalidate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawView.layoutIfNeeded()
        drawView.setupLayer(with: .box)
        
        self.path = ObjectFectory.generatePath(self.drawView.model)
        self.updatePlaneNode(with: self.path)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawView.setupLayer(with: .box)
        
    }
    
    @objc
    func runButtonTouchHandler() {
        scene = setupSceneKit()
        isRunning = false
        displaylink?.invalidate()
        sphericalInterpolate()
        isRunning = true
    }

    var isRunning: Bool = false {
        didSet {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.commit()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
         return .bottom
    }

    // MARK: Demos

    var displaylink: CADisplayLink?

    var sphericalInterpolateTime: Float = 0

    var origin = simd_float3(0, 0, 1)

    let q1 = simd_quatf(angle: 0,
                        axis: simd_normalize(simd_float3(x: 0,
                                                         y: 1,
                                                         z: 0)))

    let q2 = simd_quatf(angle: -.pi/18000,
                        axis: simd_normalize(simd_float3(x: 0,
                                                         y: 1,
                                                         z: 0)))

    func sphericalInterpolate() {

        sphericalInterpolateTime = 0

        let u1 = simd_act(q1, origin)
        let u2 = simd_act(q2, origin)

        for u in [u1, u2] {
            addSphereAt(position: u,
                        radius: 0.04,
                        color: .red,
                        scene: scene)
        }

        displaylink = CADisplayLink(target: self,
                                    selector: #selector(sphericalInterpolateStep))

        displaylink?.add(to: .current,
                         forMode: .default)

        previousLongestInterpolationPoint = nil

    }

    var previousLongestInterpolationPoint: simd_float3?

    @objc
    func sphericalInterpolateStep(displaylink: CADisplayLink) {
        guard isRunning else {
            return
        }

        let increment: Float = 0.005
        sphericalInterpolateTime += increment

        do {
            for t in [sphericalInterpolateTime,
                      sphericalInterpolateTime + increment * 0.5] {
                        let q = simd_slerp_longest(q1, q2, t)
                        let interpolationPoint = simd_act(q, origin)
                        if let previousLongestInterpolationPoint = previousLongestInterpolationPoint {
                            addLineBetweenVertices(vertexA: previousLongestInterpolationPoint, vertexB: interpolationPoint, inScene: scene, t: sphericalInterpolateTime)
                        }
                        previousLongestInterpolationPoint = interpolationPoint
            }
        }

        if !(sphericalInterpolateTime < 1) {
            self.hadTranslate = true
            self.pathNode.removeFromParentNode()
            displaylink.invalidate()
            isRunning = false
        }
    }

}

extension RevolutionVC: BezierDrawDelegate {
    func changeSpin(with index: Int) {
        spanIndex = index
        guard !isRunning else { return }
        if hadTranslate {
            scene = setupSceneKit()
            self.hadTranslate = false
        }
        self.updatePlaneNode(with: self.path)
    }
    
    func runButtonDidClicked(with path: UIBezierPath) {
        guard isRunning != true else { return }
        self.path = path
        scene = setupSceneKit()
        isRunning = false
        displaylink?.invalidate()
        self.sphericalInterpolate()
        isRunning = true
    }
    func updatePlane(with path: UIBezierPath) {
        guard !isRunning else { return }
        if hadTranslate {
            scene = setupSceneKit()
            self.hadTranslate = false
        }
        self.path = path
        self.updatePlaneNode(with: self.path)
    }
    func changeModel(with path: UIBezierPath) {
        scene = setupSceneKit()
        spanIndex = self.drawView.segmentedControl2.selectedSegmentIndex
        isRunning = false
        displaylink?.invalidate()
        self.path = path
        self.updatePlaneNode(with: self.path)
    }
}
