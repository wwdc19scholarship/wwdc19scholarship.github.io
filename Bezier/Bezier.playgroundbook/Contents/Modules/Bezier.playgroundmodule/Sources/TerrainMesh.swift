//
//  TerrainMesh.swift
//  DrawVC
//
//  Created by scauos on 2019/3/20.
//  Copyright © 2019 scauos. All rights reserved.
//

import SceneKit
import Foundation

class TerrainMesh: SCNNode {
    var meshVertices: [SCNVector3] = []
    var normals: [SCNVector3] = []
    var triangleIndices: [Int32] = []
    var textureCoordinates: [Float32]! = []
    var verticesPerSide: Int = 0
    var sideLength: Double = 0
    var vertexHeightComputationBlock: ((Int, Int) -> Double)? = nil
    
    
    init(withResolution verticesPerSide: Int, sideLength: Double, vertexComputationBlock: ((Int, Int) -> Double)?) {
        self.verticesPerSide = verticesPerSide
        self.sideLength = sideLength
        self.vertexHeightComputationBlock = vertexComputationBlock
        super.init()
        
        self.allocateDataBuffers()
        self.populateDataBuffersWithStartingValues()
        self.configureGeometry()
    }
    
    func allocateDataBuffers() {
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        meshVertices = Array(repeating: SCNVector3(), count: totalVertices)
        normals = Array(repeating: SCNVector3(), count: totalVertices)
        triangleIndices = Array(repeating: 0, count: totalTriangles * 3)
        textureCoordinates = Array(repeating: 0.0, count: totalVertices*2)
    }
    
    func populateDataBuffersWithStartingValues() {
        guard verticesPerSide > 0 else {
            assert(true)
            return
        }
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        
        for i in 0 ... totalVertices-1 {
            let ix = i % verticesPerSide
            let iy = i / verticesPerSide
            
            let ixf = Double(ix) / Double(verticesPerSide - 1)
            let iyf = Double(iy) / Double(verticesPerSide - 1)
            let x = ixf * Double(sideLength)
            let y = iyf * Double(sideLength)
            
            var vertexZDepth: Double = 0.0
            
            if (vertexHeightComputationBlock != nil) {
                vertexZDepth = vertexHeightComputationBlock!(ix, iy)
            }
            
            meshVertices[i] = SCNVector3(x, y, vertexZDepth)
            normals[i] = SCNVector3(0, 0, 1)
            
            let ti = i * 2
            textureCoordinates[ti] = Float(ixf)
            textureCoordinates[ti+1] = Float(iyf)
        }
        
        
        for i in stride(from: 0, to: totalTriangles-1, by: 2) {
            let squareIndex = i / 2
            let squareX = squareIndex % squaresPerSide
            let squareY = squareIndex / squaresPerSide
            
            let vPerSide = Int(verticesPerSide)
            let toprightIndex = ((squareY + 1) * vPerSide) + squareX + 1
            let topleftIndex = toprightIndex - 1
            let bottomLeftIndex = toprightIndex - vPerSide - 1
            let bottomRightIndex = toprightIndex - vPerSide
            
            let i1 = i * 3
            
            triangleIndices[i1] = Int32(toprightIndex)
            triangleIndices[i1+1] = Int32(topleftIndex)
            triangleIndices[i1+2] = Int32(bottomLeftIndex)
            
            triangleIndices[i1+3] = Int32(toprightIndex)
            triangleIndices[i1+4] = Int32(bottomLeftIndex)
            triangleIndices[i1+5] = Int32(bottomRightIndex)
        }
    }
    
    func configureGeometry() {
        let originalMaterials = self.geometry?.materials
        
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        
        let data = NSData(bytes: textureCoordinates, length: MemoryLayout<Float32>.size * 2 * totalVertices)
        let textureSource = SCNGeometrySource(data: data as Data,
                                              semantic: .texcoord,
                                              vectorCount: totalVertices,
                                              usesFloatComponents: true,
                                              componentsPerVector: 2,
                                              bytesPerComponent: MemoryLayout<Float32>.size,
                                              dataOffset: 0,
                                              dataStride: MemoryLayout<Float32>.size * 2)
        
        let vertexSource = SCNGeometrySource(vertices: meshVertices)
        let normalSource = SCNGeometrySource(normals: normals)
        
        let indexData = NSData(bytes: triangleIndices, length: MemoryLayout<Int32>.size * totalTriangles * 3)
        let element = SCNGeometryElement(data: indexData as Data,
                                         primitiveType: .triangles,
                                         primitiveCount: totalTriangles,
                                         bytesPerIndex: MemoryLayout<Int32>.size)
        
        let geometry = SCNGeometry(sources: [vertexSource, normalSource, textureSource], elements: [element])
        geometry.materials = originalMaterials ?? []
        
        self.geometry = geometry
    }
    
    func updateGeometry(vertexComputationBlock: ((Int, Int) -> Double)?) {
        if vertexComputationBlock != nil {
            self.vertexHeightComputationBlock = vertexComputationBlock!
            self.populateDataBuffersWithStartingValues()
            self.configureGeometry()
        }
    }
    
    func derformTerrainAt(point: CGPoint, brushRadius: Double, intensity: Double) {
        let radiusInIndices = brushRadius * Double(verticesPerSide)
        let vx = Double(verticesPerSide) * Double(point.x)
        let vy = Double(verticesPerSide) * Double(point.y)
        
        for y in 0 ... verticesPerSide-1 {
            for x in 0 ... verticesPerSide-1 {
                let xDelta = vx - Double(x)
                let yDelta = vy - Double(y)
                let dist = sqrt((xDelta * xDelta) + (yDelta * yDelta))
                
                if dist < radiusInIndices {
                    let index = y * verticesPerSide + x
                    var relativeIntensity = 1.0 - (dist / radiusInIndices)
                    
                    relativeIntensity = sin(relativeIntensity * .pi/2)
                    relativeIntensity *= intensity
                    
                    meshVertices[index].z += Float(relativeIntensity)
                }
            }
        }
        
        self.configureGeometry()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
