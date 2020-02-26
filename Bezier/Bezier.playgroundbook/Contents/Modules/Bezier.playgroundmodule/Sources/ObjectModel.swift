//
//  ObjectModel.swift
//  Book_Sources
//
//  Created by scauos on 2019/3/22.
//

import UIKit
import QuartzCore

class ObjectModel: NSObject {
    var type: ObjectType = .box
    var path: UIBezierPath = UIBezierPath()
    var points: [Point]! = []
    var controlViews: [ControlView] = []
}

struct Point {
    var point: CGPoint = CGPoint.zero
    var isCurve: Bool = false
    init(with point: CGPoint, isCurve curve: Bool = false) {
        self.point = point
        self.isCurve = curve
    }
}

class ObjectFectory: NSObject {
    static func createObject(inView view: BezierDraw, frame: CGRect, type: ObjectType) -> ObjectModel {
        var points: [Point] = []
        if type == .box {
            points = [Point(with: CGPoint(x: 1/6 * frame.width, y: 1/6 * frame.height)),
                      Point(with: CGPoint(x: 5/6 * frame.width, y: 1/6 * frame.height)),
                      Point(with: CGPoint(x: 5/6 * frame.width, y: 5/6 * frame.height)),
                      Point(with: CGPoint(x: 1/6 * frame.width, y: 5/6 * frame.height))]
        } else if type == .triangle {
            points = [Point(with: CGPoint(x: 1/3 * frame.width, y: 1/6 * frame.height)),
                      Point(with: CGPoint(x: 1/2 * frame.width, y: 5/6 * frame.height)),
                      Point(with: CGPoint(x: 2/3 * frame.width, y: 1/6 * frame.height))]
        } else if type == .circle {
            let radius = 1/3 * frame.height
            points = [Point(with: CGPoint(x: 1/2 * frame.width - radius, y: 1/2 * frame.height)),
                      Point(with: CGPoint(x: 1/2 * frame.width - radius, y: 1/2 * frame.height + radius), isCurve: true),
                      Point(with: CGPoint(x: 1/2 * frame.width, y: 1/2 * frame.height + radius), isCurve: false),
                      Point(with: CGPoint(x: 1/2 * frame.width + radius, y: 1/2 * frame.height + radius), isCurve: true),
                      Point(with: CGPoint(x: 1/2 * frame.width + radius, y: 1/2 * frame.height), isCurve: false),
                      Point(with: CGPoint(x: 1/2 * frame.width + radius, y: 1/2 * frame.height - radius), isCurve: true),
                      Point(with: CGPoint(x: 1/2 * frame.width, y: 1/2 * frame.height - radius)),
                      Point(with: CGPoint(x: 1/2 * frame.width - radius, y: 1/2 * frame.height - radius), isCurve: true)]
        } else if type == .line {
            let a = 1/2 * frame.width - 1/3 * frame.height
            let b = 1/2 * frame.height - 1/3 * frame.height
            let c = 1/2 * frame.width + 1/3 * frame.height
            let d = 1/2 * frame.height + 1/3 * frame.height
            points = [Point(with: CGPoint(x: a, y: b)),Point(with: CGPoint(x: c, y: d))]
        } else if type == .curve {
            let a = 1/2 * frame.width - 1/3 * frame.height
            let b = 1/2 * frame.height - 1/3 * frame.height
            let c = 1/2 * frame.width + 1/3 * frame.height
            let d = 1/2 * frame.height + 1/3 * frame.height
            points = [Point(with: CGPoint(x: a, y: b)),
                      Point(with: CGPoint(x: c, y: b), isCurve: true),
                      Point(with: CGPoint(x: c, y: d))]
        } else if type == .star {
            points = [Point(with: CGPoint(x: 215.96, y: 53)),
                      Point(with: CGPoint(x: 153, y: 99.92)),
                      Point(with: CGPoint(x: 90.04, y: 53)),
                      Point(with: CGPoint(x: 115.5, y: 129.78)),
                      Point(with: CGPoint(x: 53, y: 176.7)),
                      Point(with: CGPoint(x: 128, y: 176.7)),
                      Point(with: CGPoint(x: 153, y: 253)),
                      Point(with: CGPoint(x: 178, y: 176.7)),
                      Point(with: CGPoint(x: 253, y: 176.7)),
                      Point(with: CGPoint(x: 190.5, y: 129.78)),
                      Point(with: CGPoint(x: 215.96, y: 53))]
        } else if type == .swift {
            points = [Point(with: CGPoint(x: 236.19, y: 111.77)),
                      Point(with: CGPoint(x: 237.13, y: 114.57)),
                      Point(with: CGPoint(x: 236.66, y: 112.7)),
                      Point(with: CGPoint(x: 236.66, y: 113.64)),
                      Point(with: CGPoint(x: 175.9, y: 237)),
                      Point(with: CGPoint(x: 248.34, y: 158.5)),
                      Point(with: CGPoint(x: 221.7, y: 209.89)),
                      Point(with: CGPoint(x: 196.93, y: 148.68)),
                      Point(with: CGPoint(x: 196, y: 209.89)),
                      Point(with: CGPoint(x: 203.94, y: 177.66)),
                      Point(with: CGPoint(x: 194.6, y: 141.21)),
                      Point(with: CGPoint(x: 196.47, y: 146.35)),
                      Point(with: CGPoint(x: 195.53, y: 143.54)),
                      Point(with: CGPoint(x: 194.57, y: 141.22)),
                      Point(with: CGPoint(x: 190.74, y: 143.62)),
                      Point(with: CGPoint(x: 193.25, y: 141.95)),
                      Point(with: CGPoint(x: 191.98, y: 142.75)),
                      Point(with: CGPoint(x: 96.93, y: 220.64)),
                      Point(with: CGPoint(x: 190.85, y: 143.54)),
                      Point(with: CGPoint(x: 145.53, y: 171.58)),
                      Point(with: CGPoint(x: 153.94, y: 149.15)),
                      Point(with: CGPoint(x: 95.53, y: 222.04)),
                      Point(with: CGPoint(x: 123.1, y: 181.4)),
                      Point(with: CGPoint(x: 72.63, y: 210.84)),
                      Point(with: CGPoint(x: 139.46, y: 157.57)),
                      Point(with: CGPoint(x: 98.33, y: 187)),
                      Point(with: CGPoint(x: 83.84, y: 195.41)),
                      Point(with: CGPoint(x: 75.43, y: 205.69)),
                      Point(with: CGPoint(x: 79.64, y: 200.55)),
                      Point(with: CGPoint(x: 167.03, y: 108.5)),
                      Point(with: CGPoint(x: 105.34, y: 167.84)),
                      Point(with: CGPoint(x: 133.38, y: 134.2)),
                      Point(with: CGPoint(x: 76.37, y: 108.5)),
                      Point(with: CGPoint(x: 143.2, y: 94)),
                      Point(with: CGPoint(x: 110.02, y: 93.08)),
                      Point(with: CGPoint(x: 53, y: 122.52)),
                      Point(with: CGPoint(x: 67.95, y: 112.24)),
                      Point(with: CGPoint(x: 60.95, y: 116.91)),
                      Point(with: CGPoint(x: 115.16, y: 69.71)),
                      Point(with: CGPoint(x: 67.02, y: 100.55)),
                      Point(with: CGPoint(x: 88.98, y: 80.46)),
                      Point(with: CGPoint(x: 201.14, y: 69.71)),
                      Point(with: CGPoint(x: 146.47, y: 56.16)),
                      Point(with: CGPoint(x: 178.24, y: 57.09)),
                      Point(with: CGPoint(x: 201.62, y: 69.71)),
                      Point(with: CGPoint(x: 204.42, y: 71.58)),
                      Point(with: CGPoint(x: 202.55, y: 70.18)),
                      Point(with: CGPoint(x: 203.48, y: 70.65)),
                      Point(with: CGPoint(x: 249.75, y: 59.9)),
                      Point(with: CGPoint(x: 215.63, y: 77.19)),
                      Point(with: CGPoint(x: 237.6, y: 83.26)),
                      Point(with: CGPoint(x: 236.2, y: 111.77)),
                      Point(with: CGPoint(x: 253.02, y: 53.36)),
                      Point(with: CGPoint(x: 259.09, y: 83.73)),
                      Point(with: CGPoint(x: 236.19, y: 111.77))]
        } else if type == .apple {
            points = [Point(with: CGPoint(x: 212.55, y: 132.77)),
                      Point(with: CGPoint(x: 208.76, y: 150.9)),
                      Point(with: CGPoint(x: 210.12, y: 138.25)),
                      Point(with: CGPoint(x: 208.76, y: 144.4)),
                      Point(with: CGPoint(x: 209.47, y: 158.86)),
                      Point(with: CGPoint(x: 208.76, y: 153.65)),
                      Point(with: CGPoint(x: 209, y: 156.3)),
                      Point(with: CGPoint(x: 226.09, y: 184.96)),
                      Point(with: CGPoint(x: 211.47, y: 169.92)),
                      Point(with: CGPoint(x: 217.61, y: 179.05)),
                      Point(with: CGPoint(x: 230.84, y: 187.81)),
                      Point(with: CGPoint(x: 227.6, y: 186.01)),
                      Point(with: CGPoint(x: 229.19, y: 186.97)),
                      Point(with: CGPoint(x: 194.96, y: 208.79)),
                      Point(with: CGPoint(x: 219.41, y: 205.47)),
                      Point(with: CGPoint(x: 200.81, y: 208.2)),
                      Point(with: CGPoint(x: 154.55, y: 200.25)),
                      Point(with: CGPoint(x: 182.22, y: 210.09)),
                      Point(with: CGPoint(x: 164.29, y: 200.41)),
                      Point(with: CGPoint(x: 154.3, y: 200.25)),
                      Point(with: CGPoint(x: 113.9, y: 208.79)),
                      Point(with: CGPoint(x: 144.57, y: 200.41)),
                      Point(with: CGPoint(x: 126.64, y: 210.09)),
                      Point(with: CGPoint(x: 75.1, y: 184.96)),
                      Point(with: CGPoint(x: 107.56, y: 208.15)),
                      Point(with: CGPoint(x: 87.31, y: 204.03)),
                      Point(with: CGPoint(x: 66.16, y: 158.86)),
                      Point(with: CGPoint(x: 70.82, y: 178.27)),
                      Point(with: CGPoint(x: 67.52, y: 169.74)),
                      Point(with: CGPoint(x: 65.5, y: 146.16)),
                      Point(with: CGPoint(x: 65.67, y: 154.94)),
                      Point(with: CGPoint(x: 65.44, y: 150.71)),
                      Point(with: CGPoint(x: 66.57, y: 132.77)),
                      Point(with: CGPoint(x: 65.56, y: 141.59)),
                      Point(with: CGPoint(x: 65.93, y: 137.12)),
                      Point(with: CGPoint(x: 73.83, y: 106.67)),
                      Point(with: CGPoint(x: 67.94, y: 123.47)),
                      Point(with: CGPoint(x: 70.51, y: 114.7)),
                      Point(with: CGPoint(x: 87.04, y: 82.94)),
                      Point(with: CGPoint(x: 77.52, y: 97.76)),
                      Point(with: CGPoint(x: 82.13, y: 89.75)),
                      Point(with: CGPoint(x: 117.13, y: 59.01)),
                      Point(with: CGPoint(x: 97.9, y: 67.88)),
                      Point(with: CGPoint(x: 110.2, y: 59.16)),
                      Point(with: CGPoint(x: 153.98, y: 67.89)),
                      Point(with: CGPoint(x: 131.38, y: 58.69)),
                      Point(with: CGPoint(x: 143.76, y: 68.14)),
                      Point(with: CGPoint(x: 154.3, y: 67.87)),
                      Point(with: CGPoint(x: 154.09, y: 67.87)),
                      Point(with: CGPoint(x: 154.2, y: 67.86)),
                      Point(with: CGPoint(x: 154.43, y: 67.87)),
                      Point(with: CGPoint(x: 154.55, y: 67.87)),
                      Point(with: CGPoint(x: 154.87, y: 67.89)),
                      Point(with: CGPoint(x: 154.66, y: 67.86)),
                      Point(with: CGPoint(x: 154.77, y: 67.87)),
                      Point(with: CGPoint(x: 191.74, y: 59.01)),
                      Point(with: CGPoint(x: 165.09, y: 68.15)),
                      Point(with: CGPoint(x: 177.48, y: 58.69)),
                      Point(with: CGPoint(x: 221.83, y: 82.94)),
                      Point(with: CGPoint(x: 198.66, y: 59.16)),
                      Point(with: CGPoint(x: 210.96, y: 67.88)),
                      Point(with: CGPoint(x: 235.03, y: 106.67)),
                      Point(with: CGPoint(x: 226.73, y: 89.75)),
                      Point(with: CGPoint(x: 231.34, y: 97.76)),
                      Point(with: CGPoint(x: 236.61, y: 110.71)),
                      Point(with: CGPoint(x: 235.58, y: 108)),
                      Point(with: CGPoint(x: 236.1, y: 109.34)),
                      Point(with: CGPoint(x: 212.55, y: 132.77)),
                      Point(with: CGPoint(x: 226, y: 113.97)),
                      Point(with: CGPoint(x: 217.27, y: 122.11)),
                      Point(with: CGPoint(x: 179.46, y: 222.08)),
                      Point(with: CGPoint(x: 188.99, y: 253.88)),
                      Point(with: CGPoint(x: 190.39, y: 234.78)),
                      Point(with: CGPoint(x: 189.97, y: 253.07)),
                      Point(with: CGPoint(x: 158.69, y: 239.16)),
                      Point(with: CGPoint(x: 188, y: 254.7)),
                      Point(with: CGPoint(x: 169.91, y: 251.44)),
                      Point(with: CGPoint(x: 149.16, y: 207.36)),
                      Point(with: CGPoint(x: 147.48, y: 226.87)),
                      Point(with: CGPoint(x: 148.17, y: 208.17)),
                      Point(with: CGPoint(x: 179.46, y: 222.08)),
                      Point(with: CGPoint(x: 150.15, y: 206.54)),
                      Point(with: CGPoint(x: 168.52, y: 209.37))]
        } else if type == .wwdc {
            let start = 1/6 * frame.width
            let space = 2/3 * frame.width * 1/10
            let spaceY = 1/3 * frame.height
            points = [Point(with: CGPoint(x: start, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+1/2*space, y: spaceY)),
                      Point(with: CGPoint(x: start+space, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+3/2*space, y: spaceY)),
                      Point(with: CGPoint(x: start+2*space, y: 2*spaceY)),
                      
                      Point(with: CGPoint(x: start+3*space, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+7/2*space, y: spaceY)),
                      Point(with: CGPoint(x: start+8/2*space, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+9/2*space, y: spaceY)),
                      Point(with: CGPoint(x: start+5*space, y: 2*spaceY)),
                
                      Point(with: CGPoint(x: start+6*space, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+7*space, y: 2*spaceY), isCurve: true),
                      Point(with: CGPoint(x: start+7*space, y: spaceY), isCurve: true),
                      Point(with: CGPoint(x: start+6*space, y: spaceY)),

                      Point(with: CGPoint(x: start+8*space, y: 1/2*frame.height)),
                      Point(with: CGPoint(x: start+8*space, y: 2*spaceY), isCurve: true),
                      Point(with: CGPoint(x: start+9*space, y: 2*spaceY)),
                      Point(with: CGPoint(x: start+9*space, y: spaceY)),
                      Point(with: CGPoint(x: start+8*space, y: spaceY), isCurve: true),
            ]
        }
        let object = ObjectModel()
        if type != .star && type != .swift && type != .apple {
            for point in points {
                object.controlViews.append(view.createPointView(withPosition: point.point))
            }
        } else {
            object.controlViews = []
        }
        object.path = updatePath(for: type, for: points)
        object.points = points
        object.type = type
        return object
    }
    
    static func updatePath(for type: ObjectType, for points: [Point]) -> UIBezierPath {
        var path = UIBezierPath()
        if type == .box {
            path.move(to: points[0].point)
            path.addLine(to: points[1].point)
            path.addLine(to: points[2].point)
            path.addLine(to: points[3].point)
            path.close()
        } else if type == .triangle {
            path.move(to: points[0].point)
            path.addLine(to: points[1].point)
            path.addLine(to: points[2].point)
            path.close()
        } else if type == .circle {
            path.move(to: points[0].point)
            path.addQuadCurve(to: points[2].point, controlPoint: points[1].point)
            path.addQuadCurve(to: points[4].point, controlPoint: points[3].point)
            path.addQuadCurve(to: points[6].point, controlPoint: points[5].point)
            path.addQuadCurve(to: points[0].point, controlPoint: points[7].point)
        } else if type == .line {
            path.move(to: points[0].point)
            path.addLine(to: points[1].point)
            path.addLine(to: CGPoint(x: points[1].point.x+0.01, y: points[1].point.y))
            path.addLine(to: CGPoint(x: points[0].point.x+0.01, y: points[0].point.y))
            path.close()
        } else if type == .curve {
            path.move(to: points[0].point)
            path.addQuadCurve(to: points[2].point, controlPoint: points[1].point)
            path.addLine(to: CGPoint(x: points[2].point.x+0.01, y: points[2].point.y))
            path.addQuadCurve(to: CGPoint(x: points[0].point.x+0.01, y: points[0].point.y), controlPoint: CGPoint(x: points[1].point.x+0.01, y: points[1].point.y))
            path.close()
        } else if type == .star {
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: points[0].point.x, y: points[0].point.y))
            bezierPath.addLine(to: CGPoint(x: points[1].point.x, y: points[1].point.y))
            bezierPath.addLine(to: CGPoint(x: points[2].point.x, y: points[2].point.y))
            bezierPath.addLine(to: CGPoint(x: points[3].point.x, y: points[3].point.y))
            bezierPath.addLine(to: CGPoint(x: points[4].point.x, y: points[4].point.y))
            bezierPath.addLine(to: CGPoint(x: points[5].point.x, y: points[5].point.y))
            bezierPath.addLine(to: CGPoint(x: points[6].point.x, y: points[6].point.y))
            bezierPath.addLine(to: CGPoint(x: points[7].point.x, y: points[7].point.y))
            bezierPath.addLine(to: CGPoint(x: points[8].point.x, y: points[8].point.y))
            bezierPath.addLine(to: CGPoint(x: points[9].point.x, y: points[9].point.y))
            bezierPath.addLine(to: CGPoint(x: points[10].point.x, y: points[10].point.y))
            bezierPath.close()
            path = bezierPath
            
        } else if type == .swift {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: points[0].point.x, y: points[0].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[1].point.x, y: points[1].point.y), controlPoint1: CGPoint(x: points[2].point.x, y: points[2].point.y), controlPoint2: CGPoint(x: points[3].point.x, y: points[3].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[4].point.x, y: points[4].point.y), controlPoint1: CGPoint(x: points[5].point.x, y: points[5].point.y), controlPoint2: CGPoint(x: points[6].point.x, y: points[6].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[7].point.x, y: points[7].point.y), controlPoint1: CGPoint(x: points[8].point.x, y: points[8].point.y), controlPoint2: CGPoint(x: points[9].point.x, y: points[9].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[10].point.x, y: points[10].point.y), controlPoint1: CGPoint(x: points[11].point.x, y: points[11].point.y), controlPoint2: CGPoint(x: points[12].point.x, y: points[12].point.y))
                bezierPath.addLine(to: CGPoint(x: points[13].point.x, y: points[13].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[14].point.x, y: points[14].point.y), controlPoint1: CGPoint(x: points[15].point.x, y: points[15].point.y), controlPoint2: CGPoint(x: points[16].point.x, y: points[16].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[17].point.x, y: points[17].point.y), controlPoint1: CGPoint(x: points[18].point.x, y: points[18].point.y), controlPoint2: CGPoint(x: points[19].point.x, y: points[19].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[20].point.x, y: points[20].point.y), controlPoint1: CGPoint(x: points[21].point.x, y: points[21].point.y), controlPoint2: CGPoint(x: points[22].point.x, y: points[22].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[23].point.x, y: points[23].point.y), controlPoint1: CGPoint(x: points[24].point.x, y: points[24].point.y), controlPoint2: CGPoint(x: points[25].point.x, y: points[25].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[26].point.x, y: points[26].point.y), controlPoint1: CGPoint(x: points[27].point.x, y: points[27].point.y), controlPoint2: CGPoint(x: points[28].point.x, y: points[28].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[29].point.x, y: points[29].point.y), controlPoint1: CGPoint(x: points[30].point.x, y: points[30].point.y), controlPoint2: CGPoint(x: points[31].point.x, y: points[31].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[32].point.x, y: points[32].point.y), controlPoint1: CGPoint(x: points[33].point.x, y: points[33].point.y), controlPoint2: CGPoint(x: points[34].point.x, y: points[34].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[35].point.x, y: points[35].point.y), controlPoint1: CGPoint(x: points[36].point.x, y: points[36].point.y), controlPoint2: CGPoint(x: points[37].point.x, y: points[37].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[38].point.x, y: points[38].point.y), controlPoint1: CGPoint(x: points[39].point.x, y: points[39].point.y), controlPoint2: CGPoint(x: points[40].point.x, y: points[40].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[41].point.x, y: points[41].point.y), controlPoint1: CGPoint(x: points[42].point.x, y: points[42].point.y), controlPoint2: CGPoint(x: points[43].point.x, y: points[43].point.y))
                bezierPath.addLine(to: CGPoint(x: points[44].point.x, y: points[44].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[45].point.x, y: points[45].point.y), controlPoint1: CGPoint(x: points[46].point.x, y: points[46].point.y), controlPoint2: CGPoint(x: points[47].point.x, y: points[47].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[48].point.x, y: points[48].point.y), controlPoint1: CGPoint(x: points[49].point.x, y: points[49].point.y), controlPoint2: CGPoint(x: points[50].point.x, y: points[50].point.y))
                bezierPath.addCurve(to: CGPoint(x: points[51].point.x, y: points[51].point.y), controlPoint1: CGPoint(x: points[52].point.x, y: points[52].point.y), controlPoint2: CGPoint(x: points[53].point.x, y: points[53].point.y))
                bezierPath.addLine(to: CGPoint(x: points[54].point.x, y: points[54].point.y))
                bezierPath.close()
            path = bezierPath
        } else if type == .apple {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: points[0].point.x, y: points[0].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[1].point.x, y: points[1].point.y), controlPoint1: CGPoint(x: points[2].point.x, y: points[2].point.y), controlPoint2: CGPoint(x: points[3].point.x, y: points[3].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[4].point.x, y: points[4].point.y), controlPoint1: CGPoint(x: points[5].point.x, y: points[5].point.y), controlPoint2: CGPoint(x: points[6].point.x, y: points[6].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[7].point.x, y: points[7].point.y), controlPoint1: CGPoint(x: points[8].point.x, y: points[8].point.y), controlPoint2: CGPoint(x: points[9].point.x, y: points[9].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[10].point.x, y: points[10].point.y), controlPoint1: CGPoint(x: points[11].point.x, y: points[11].point.y), controlPoint2: CGPoint(x: points[12].point.x, y: points[12].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[13].point.x, y: points[13].point.y), controlPoint1: CGPoint(x: points[14].point.x, y: points[14].point.y), controlPoint2: CGPoint(x: points[15].point.x, y: points[15].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[16].point.x, y: points[16].point.y), controlPoint1: CGPoint(x: points[17].point.x, y: points[17].point.y), controlPoint2: CGPoint(x: points[18].point.x, y: points[18].point.y))
            bezierPath.addLine(to: CGPoint(x: points[19].point.x, y: points[19].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[20].point.x, y: points[20].point.y), controlPoint1: CGPoint(x: points[21].point.x, y: points[21].point.y), controlPoint2: CGPoint(x: points[22].point.x, y: points[22].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[23].point.x, y: points[23].point.y), controlPoint1: CGPoint(x: points[24].point.x, y: points[24].point.y), controlPoint2: CGPoint(x: points[25].point.x, y: points[25].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[26].point.x, y: points[26].point.y), controlPoint1: CGPoint(x: points[27].point.x, y: points[27].point.y), controlPoint2: CGPoint(x: points[28].point.x, y: points[28].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[29].point.x, y: points[29].point.y), controlPoint1: CGPoint(x: points[30].point.x, y: points[30].point.y), controlPoint2: CGPoint(x: points[31].point.x, y: points[31].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[32].point.x, y: points[32].point.y), controlPoint1: CGPoint(x: points[33].point.x, y: points[33].point.y), controlPoint2: CGPoint(x: points[34].point.x, y: points[34].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[35].point.x, y: points[35].point.y), controlPoint1: CGPoint(x: points[36].point.x, y: points[36].point.y), controlPoint2: CGPoint(x: points[37].point.x, y: points[37].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[38].point.x, y: points[38].point.y), controlPoint1: CGPoint(x: points[39].point.x, y: points[39].point.y), controlPoint2: CGPoint(x: points[40].point.x, y: points[40].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[41].point.x, y: points[41].point.y), controlPoint1: CGPoint(x: points[42].point.x, y: points[42].point.y), controlPoint2: CGPoint(x: points[43].point.x, y: points[43].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[44].point.x, y: points[44].point.y), controlPoint1: CGPoint(x: points[45].point.x, y: points[45].point.y), controlPoint2: CGPoint(x: points[46].point.x, y: points[46].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[47].point.x, y: points[47].point.y), controlPoint1: CGPoint(x: points[48].point.x, y: points[48].point.y), controlPoint2: CGPoint(x: points[49].point.x, y: points[49].point.y))
            bezierPath.addLine(to: CGPoint(x: points[50].point.x, y: points[50].point.y))
            bezierPath.addLine(to: CGPoint(x: points[51].point.x, y: points[51].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[52].point.x, y: points[52].point.y), controlPoint1: CGPoint(x: points[53].point.x, y: points[53].point.y), controlPoint2: CGPoint(x: points[54].point.x, y: points[54].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[55].point.x, y: points[55].point.y), controlPoint1: CGPoint(x: points[56].point.x, y: points[56].point.y), controlPoint2: CGPoint(x: points[57].point.x, y: points[57].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[58].point.x, y: points[58].point.y), controlPoint1: CGPoint(x: points[59].point.x, y: points[59].point.y), controlPoint2: CGPoint(x: points[60].point.x, y: points[60].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[61].point.x, y: points[61].point.y), controlPoint1: CGPoint(x: points[62].point.x, y: points[62].point.y), controlPoint2: CGPoint(x: points[63].point.x, y: points[63].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[64].point.x, y: points[64].point.y), controlPoint1: CGPoint(x: points[65].point.x, y: points[65].point.y), controlPoint2: CGPoint(x: points[66].point.x, y: points[66].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[67].point.x, y: points[67].point.y), controlPoint1: CGPoint(x: points[68].point.x, y: points[68].point.y), controlPoint2: CGPoint(x: points[69].point.x, y: points[69].point.y))
            bezierPath.close()
            
            
            //// Bezier 2 Drawing
            bezierPath.move(to: CGPoint(x: points[70].point.x, y: points[70].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[71].point.x, y: points[71].point.y), controlPoint1: CGPoint(x: points[72].point.x, y: points[72].point.y), controlPoint2: CGPoint(x: points[73].point.x, y: points[73].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[74].point.x, y: points[74].point.y), controlPoint1: CGPoint(x: points[75].point.x, y: points[75].point.y), controlPoint2: CGPoint(x: points[76].point.x, y: points[76].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[77].point.x, y: points[77].point.y), controlPoint1: CGPoint(x: points[78].point.x, y: points[78].point.y), controlPoint2: CGPoint(x: points[79].point.x, y: points[79].point.y))
            bezierPath.addCurve(to: CGPoint(x: points[80].point.x, y: points[80].point.y), controlPoint1: CGPoint(x: points[81].point.x, y: points[81].point.y), controlPoint2: CGPoint(x: points[82].point.x, y: points[82].point.y))
            bezierPath.close()
            path = bezierPath
        } else if type == .wwdc {
            //W
            path.move(to: points[0].point)
            path.addLine(to: points[1].point)
            path.addLine(to: points[2].point)
            path.addLine(to: points[3].point)
            path.addLine(to: points[4].point)
            path.addLine(to: CGPoint(x: points[4].point.x, y: points[4].point.y+0.01))
            path.addLine(to: CGPoint(x: points[4].point.x+0.01, y: points[4].point.y+0.01))
            path.addLine(to: points[4].point)
            path.move(to: CGPoint(x: points[4].point.x+0.01, y: points[4].point.y))
            path.addLine(to: CGPoint(x: points[3].point.x+0.01, y: points[3].point.y))
            path.addLine(to: points[3].point)
            path.move(to: CGPoint(x: points[3].point.x+0.01, y: points[3].point.y))
            path.addLine(to: CGPoint(x: points[2].point.x+0.01, y: points[2].point.y))
            path.addLine(to: points[2].point)
            path.move(to: CGPoint(x: points[2].point.x+0.01, y: points[2].point.y))
            path.addLine(to: CGPoint(x: points[1].point.x+0.01, y: points[1].point.y))
            path.addLine(to: CGPoint(x: points[1].point.x, y: points[1].point.y))
            path.move(to: CGPoint(x: points[1].point.x+0.01, y: points[1].point.y))
            path.addLine(to: CGPoint(x: points[0].point.x+0.01, y: points[0].point.y))
            path.addLine(to: CGPoint(x: points[0].point.x, y: points[0].point.y))
            
            //W
            path.move(to: points[5].point)
            path.addLine(to: points[6].point)
            path.addLine(to: points[7].point)
            path.addLine(to: points[8].point)
            path.addLine(to: points[9].point)
            path.addLine(to: CGPoint(x: points[9].point.x, y: points[9].point.y+0.01))
            path.addLine(to: CGPoint(x: points[9].point.x+0.01, y: points[9].point.y+0.01))
            path.addLine(to: points[9].point)
            path.move(to: CGPoint(x: points[9].point.x+0.01, y: points[9].point.y))
            path.addLine(to: CGPoint(x: points[8].point.x+0.01, y: points[8].point.y))
            path.addLine(to: points[8].point)
            path.move(to: CGPoint(x: points[8].point.x+0.01, y: points[8].point.y))
            path.addLine(to: CGPoint(x: points[7].point.x+0.01, y: points[7].point.y))
            path.addLine(to: points[7].point)
            path.move(to: CGPoint(x: points[7].point.x+0.01, y: points[7].point.y))
            path.addLine(to: CGPoint(x: points[6].point.x+0.01, y: points[6].point.y))
            path.addLine(to: CGPoint(x: points[6].point.x, y: points[6].point.y))
            path.move(to: CGPoint(x: points[6].point.x+0.01, y: points[6].point.y))
            path.addLine(to: CGPoint(x: points[5].point.x+0.01, y: points[5].point.y))
            path.addLine(to: CGPoint(x: points[5].point.x, y: points[5].point.y))
            
            //D
            path.move(to: points[10].point)
            path.addCurve(to: points[13].point, controlPoint1: points[11].point, controlPoint2: points[12].point)
            path.addLine(to: CGPoint(x: points[13].point.x+0.01, y: points[13].point.y))
            path.addCurve(to: CGPoint(x: points[10].point.x+0.01, y: points[10].point.y), controlPoint1: CGPoint(x: points[12].point.x+0.01, y: points[12].point.y), controlPoint2: CGPoint(x: points[11].point.x+0.01, y: points[11].point.y))
            path.addLine(to: points[10].point)
            path.move(to: CGPoint(x: points[10].point.x+0.01, y: points[10].point.y))
            path.addLine(to: CGPoint(x: points[13].point.x+0.01, y: points[13].point.y))
            path.addLine(to: points[13].point)
            path.close()
            
            //C
            path.move(to: points[16].point)
            path.addQuadCurve(to: points[14].point, controlPoint: points[15].point)
            path.addQuadCurve(to: points[17].point, controlPoint: points[18].point)
            path.addLine(to: CGPoint(x: points[17].point.x+0.01, y: points[17].point.y))
            path.addQuadCurve(to: CGPoint(x: points[14].point.x+0.01, y: points[14].point.y), controlPoint: CGPoint(x: points[18].point.x+0.01, y: points[18].point.y))
            path.addQuadCurve(to: CGPoint(x: points[16].point.x+0.01, y: points[16].point.y), controlPoint: CGPoint(x: points[15].point.x+0.01, y: points[15].point.y))
            path.addLine(to: points[16].point)
            
            
            
        }
        return path
    }
    
    static func generatePath(_ model: ObjectModel) -> UIBezierPath {
        var points = model.points!
        var minX = points.map{ $0.point.x }.min()!
        var maxX = points.map{ $0.point.x }.max()!
        let minY = points.map{ $0.point.y }.min()!
        let maxY = points.map{ $0.point.y }.max()!
        let width = maxX - minX
        let height = maxY - minY
        // Clip X'
        for i in 0 ..< points.count {
            points[i].point.x = maxX + minX - points[i].point.x
        }
        var w: CGFloat!
        var h: CGFloat!
        if model.type == .wwdc {
            w = 1.5/width
            h = 1/height
        } else {
            w = 1/width
            h = 1/height
        }
        swap(&minX, &maxX)
        for i in 0 ..< points.count {
            points[i].point.x = (points[i].point.x - minX) * w
            points[i].point.y = (points[i].point.y - minY) * h
        }
        let path = self.updatePath(for: model.type, for: points)
        return path
    }
}
