/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/
/*
import ARKit
import SceneKit
import UIKit
import PlaygroundSupport

class ARViewController: UIViewController, ARSCNViewDelegate, PlaygroundLiveViewSafeAreaContainer {
    
    var textNode: SCNNode? = nil
    
    var sceneView: ARSCNView! = {
        let sceneView = ARSCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    var blurView: UIVisualEffectView! = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isHidden = true
        return blurView
    }()
    
    lazy var containerView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.statusViewController = StatusViewController()
        statusViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(statusViewController)
        view.addSubview(statusViewController.view)
        statusViewController.didMove(toParent: self)
        return view
    }()
    
    /// The view controller that displays the status and "restart experience" UI.
    var statusViewController: StatusViewController!
    
//    lazy var statusViewController: StatusViewController = {
//        return childViewControllers.lazy.compactMap({ $0 as? StatusViewController }).first!
//    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - Setup View
    func setupView() {
        view.addSubview(sceneView)
        sceneView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor).isActive = true
        
        view.addSubview(blurView)
        blurView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        statusViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        statusViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        statusViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        statusViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        sceneView.delegate = self
        sceneView.session.delegate = self

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
            self.textNode?.removeFromParentNode()
            self.textNode = nil
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		//UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}

    // MARK: - Session management (Image detection setup)
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true

    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
	func resetTracking() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
	}

    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        updateQueue.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
            
            guard self.textNode == nil else { return }
            let text = SCNText(string: "WWDC19", extrusionDepth: 1)
            text.chamferRadius = 0.5
            text.flatness = 0.1
            text.firstMaterial?.lightingModel = .phong
            text.firstMaterial?.diffuse.contents = UIColor.red
            
            self.textNode = SCNNode(geometry: text)
            self.textNode?.eulerAngles.x = -.pi/2
            node.addChildNode(self.textNode!)
        }

        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
    }

    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
}
**/

