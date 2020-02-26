//
//  MeshVC.swift
//  DrawVC
//
//  Created by scauos on 2019/3/20.
//  Copyright © 2019 scauos. All rights reserved.
//

import UIKit
import SceneKit
import PlaygroundSupport

class MeshVC: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    var cameraButton = UIButton()
    let wireframeButton = UIButton()
    var mesh: TerrainMesh!
    lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "smile.png")
        material.isDoubleSided = true
        return material
    }()
    var isShowNetwork = true
    var kMeshResolution = 100
    
    lazy var imagePickerVC: UIImagePickerController = {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        return imagePickerVC
    }()
    
    var intensity: Double = 0.1
    
    var sceneView: SCNView!
    var scene: SCNScene! = {
        let scene = SCNScene(named: "art.scnassets/scene.scn")
        return scene
    }()
    
    lazy var segmentedControl: UISegmentedControl! = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "凹", at: 0, animated: true)
        segment.insertSegment(withTitle: "凸", at: 1, animated: true)
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(valueDidChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    func setupView() {
        sceneView = SCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //sceneView.allowsCameraControl = true
        
        sceneView.scene = scene
        sceneView.debugOptions = .showWireframe
        
        view.addSubview(segmentedControl)
        segmentedControl.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor, constant: 20).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "photo.png"), for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor, constant: -20).isActive = true
        button.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(changeBackground(_:)), for: .touchUpInside)
        
        let resetButton = UIButton()
        view.addSubview(resetButton)
        resetButton.setImage(UIImage(named: "rotate.png"), for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.leadingAnchor.constraint(equalTo: segmentedControl.trailingAnchor, constant: 20).isActive = true
        resetButton.topAnchor.constraint(equalTo: segmentedControl.topAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        resetButton.addTarget(self, action: #selector(reset(_:)), for: .touchUpInside)
        
        
        view.addSubview(cameraButton)
        cameraButton.setImage(UIImage(named: "camera-1.png"), for: .normal)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 20).isActive = true
        cameraButton.topAnchor.constraint(equalTo: resetButton.topAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cameraButton.addTarget(self, action: #selector(lockCamera(_:)), for: .touchUpInside)
        
        view.addSubview(wireframeButton)
        wireframeButton.setImage(UIImage(named: "network.png"), for: .normal)
        wireframeButton.translatesAutoresizingMaskIntoConstraints = false
        wireframeButton.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 20).isActive = true
        wireframeButton.topAnchor.constraint(equalTo: resetButton.topAnchor).isActive = true
        wireframeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        wireframeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        wireframeButton.addTarget(self, action: #selector(showNetwork(_:)), for: .touchUpInside)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createMesh()
    }
    
    
    
    func createMesh() {
        if let node = scene.rootNode.childNode(withName: "mesh", recursively: true) {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.2
            node.position.z -= 10
            node.opacity = 0.0
            SCNTransaction.completionBlock = {
                node.removeFromParentNode()
            }
            SCNTransaction.commit()
        }

        mesh = TerrainMesh(withResolution: kMeshResolution, sideLength: 10.0, vertexComputationBlock: nil)
        mesh.geometry?.firstMaterial = material
        mesh.position.z -= 10
        mesh.opacity = 0.0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2.2
        mesh.rotation = SCNVector4(1.0, 0.2, 0, -.pi/4)
        mesh.position = SCNVector3(0,2,0)
        mesh.position.z += 10
        mesh.opacity = 1
        SCNTransaction.commit()
        mesh.name = "mesh"
        scene.rootNode.addChildNode(mesh)
    }
    
    func applyDeformToMesh(touch: UITouch!) {
        let point = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(point, options: nil)
        
        for result in hitResults {
            if let node = result.node as? TerrainMesh {
                let meshSize = node.sideLength
                let relativeLocation = CGPoint(x: CGFloat(result.localCoordinates.x/Float(meshSize)), y: CGFloat(result.localCoordinates.y/Float(meshSize)))
                node.derformTerrainAt(point: relativeLocation, brushRadius: 0.1, intensity: intensity)
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.sceneView.allowsCameraControl {
            self.applyDeformToMesh(touch: touches.first!)
        } else {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.sceneView.allowsCameraControl {
            applyDeformToMesh(touch: touches.first!)
        } else {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func valueDidChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            intensity = -0.1
        } else {
            intensity = 0.1
        }
    }
    
    @objc func changeBackground(_ button: UIButton!) {
        present(self.imagePickerVC, animated: true, completion: nil)
    }
    
    @objc func reset(_ button: UIButton!) {
        createMesh()
    }
    
    @objc func lockCamera(_ button: UIButton) {
        if self.sceneView.allowsCameraControl {
            cameraButton.setImage(UIImage(named: "camera-1.png"), for: .normal)
        } else {
            cameraButton.setImage(UIImage(named: "camera.png"), for: .normal)
        }
        self.sceneView.allowsCameraControl = !self.sceneView.allowsCameraControl
    }
    @objc func showNetwork(_ button: UIButton) {
        if !isShowNetwork {
            sceneView.debugOptions = .showWireframe
            wireframeButton.setImage(UIImage(named: "network.png"), for: .normal)
        } else {
            sceneView.debugOptions = .showBoundingBoxes
            wireframeButton.setImage(UIImage(named: "network-1.png"), for: .normal)
        }
        isShowNetwork = !isShowNetwork
    }
}

extension MeshVC: PlaygroundLiveViewMessageHandler {
    func receive(_ message: PlaygroundValue) {
        switch message {
        case .dictionary(let dir):
            if case let .integer(value)? = dir["kMeshCountPerside"] {
                if value < 2 {
                    let alertController = UIAlertController(title: "Error", message: "mesh count should be larger than 2 😯, and do you know why?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else if value > 200 {
                    let alertController = UIAlertController(title: "Error", message: "mesh count not be larger than 200 😆", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    kMeshResolution = value
                    self.createMesh()
                }
            }
            default:
                break
        }
    }
}


extension MeshVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true) {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.2
            self.material.diffuse.contents = chosenImage
            self.mesh.geometry?.materials = [self.material]
            SCNTransaction.commit()
        }
    }
}
