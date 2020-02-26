/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Class containing methods for SceneKit scene rendering.
*/

import UIKit
import simd
import SceneKit

extension RevolutionVC {
    func degreesToRadians(_ degrees: Float) -> Float {
        return degrees * .pi / 180
    }

    func setupSceneKit(shadows: Bool = true) -> SCNScene {
        //sceneKitView.allowsCameraControl = true

        let scene = SCNScene()
        sceneKitView.scene = scene

        scene.background.contents = UIColor(red: 41 / 255,
                                            green: 42 / 255,
                                            blue: 48 / 255,
                                            alpha: 1)

        let lookAtNode = SCNNode()

        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.name = "cameraNode"
        cameraNode.camera = camera
        camera.fieldOfView = 25
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 1.5
        cameraNode.position = SCNVector3(x: -10, y: 2.5, z: 0)
        let lookAt = SCNLookAtConstraint(target: lookAtNode)
        lookAt.isGimbalLockEnabled = true
        cameraNode.constraints = [ lookAt ]

        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: -1.5, y: 2.5, z: 1.5)

        if shadows {
            light.type = .directional
            light.castsShadow = true
            light.shadowSampleCount = 8
            lightNode.constraints = [ lookAt ]
        }

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.color = UIColor(white: 0.5, alpha: 1)
        let ambientNode = SCNNode()
        ambientNode.light = ambient

        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(ambientNode)
        
        addMainSphere(scene: scene)

        return scene
    }
    
    func addLineBetweenVertices(vertexA: simd_float3,
                                vertexB: simd_float3,
                                inScene scene: SCNScene,
                                useSpheres: Bool = true,
                                color: UIColor = .yellow,
                                t: Float) {
        if useSpheres {
            addSphereAt(position: vertexB,
                        radius: 0.01,
                        color: .red,
                        scene: scene,
                        t: t)
        } else {
            let geometrySource = SCNGeometrySource(vertices: [SCNVector3(x: vertexA.x,
                                                                         y: vertexA.y,
                                                                         z: vertexA.z),
                                                              SCNVector3(x: vertexB.x,
                                                                         y: vertexB.y,
                                                                         z: vertexB.z)])
            let indices: [Int8] = [0, 1]
            let indexData = Data(bytes: indices, count: 2)
            let element = SCNGeometryElement(data: indexData,
                                             primitiveType: .line,
                                             primitiveCount: 1,
                                             bytesPerIndex: MemoryLayout<Int8>.size)
            
            let geometry = SCNGeometry(sources: [geometrySource],
                                       elements: [element])
            
            geometry.firstMaterial?.isDoubleSided = true
            geometry.firstMaterial?.emission.contents = color
            
            let node = SCNNode(geometry: geometry)
            
            scene.rootNode.addChildNode(node)
        }
    }


    @discardableResult
    func addSphereAt(position: simd_float3, radius: CGFloat = 0.1, color: UIColor, scene: SCNScene, t: Float? = nil) -> SCNNode {
        path.flatness = 0.01
        let sphere = SCNShape(path: path, extrusionDepth: 0.05)
        sphere.firstMaterial?.diffuse.contents = color
        sphere.firstMaterial?.isDoubleSided = true
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.simdPosition = position
        if let t = t {
            let rotation = simd_float3(x: 0, y: Float.pi/2 + Float.pi * t * 2, z: 0)
            sphereNode.simdEulerAngles = rotation
        } else {
            sphereNode.eulerAngles = SCNVector3(0, Float.pi/2, 0)
        }
        scene.rootNode.addChildNode(sphereNode)
        return sphereNode
    }
    
    func updatePlaneNode(with path: UIBezierPath) {
        path.flatness = 0.01
        pathNode.removeFromParentNode()
        let sphere = SCNShape(path: path, extrusionDepth: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.green
        sphere.firstMaterial?.isDoubleSided = true
        pathNode = SCNNode(geometry: sphere)
        
        let q = simd_slerp_longest(q1, q2, 0)
        let interpolationPoint = simd_act(q, origin)
        pathNode.simdPosition = interpolationPoint
        let rotation = simd_float3(x: 0, y: Float.pi/2, z: 0)
        pathNode.simdEulerAngles = rotation
        scene.rootNode.addChildNode(pathNode)
    }

    func addMainSphere(scene: SCNScene) {
        let sphereRotation = simd_float3(x: degreesToRadians(0), y: 0, z: 0) // was 30
        let sphere = SCNCapsule(capRadius: 0.01, height: 2)
        //let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial?.transparency = 0.85
        sphere.firstMaterial?.locksAmbientWithDiffuse = true
        sphere.firstMaterial?.diffuse.contents = UIColor(red: 0.75, green: 0.5, blue: 0.5, alpha: 1)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.simdEulerAngles = sphereRotation
        scene.rootNode.addChildNode(sphereNode)
        let wireFrameSphere = SCNCapsule(capRadius: 0.01, height: 2)
        wireFrameSphere.firstMaterial?.fillMode = .lines
        wireFrameSphere.firstMaterial?.shininess = 1
        wireFrameSphere.firstMaterial?.diffuse.contents = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        let wireFrameSphereNode = SCNNode(geometry: wireFrameSphere)
        wireFrameSphereNode.simdEulerAngles = sphereRotation
        scene.rootNode.addChildNode(wireFrameSphereNode)
    }
}
