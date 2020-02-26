/*:
 ## Hello, Welcome
 
 In this playground we are going to learn about **Bézier curve**. See how does the computer draw the curve? 🧐
 
 - Note:
 A Bézier curve (pronounced [bezje] in French) is a parametric curve used in computer graphics and related fields,  is named after **Pierre Bézier**, who used it in the 1960s for designing curves for the bodywork of Renault cars 🚗.
 \
 \
 Wikipedia
 
 
 ![Pierre Bézier](PierreBézier.jpg)
 
 - Important:
 A Bézier curve is defined by a set of control points **P0** through **Pn**, where **n** is called its order (n = 1 for **linear**, 2 for **quadratic**, 3 for **cubic**, etc.). The first and last control points are always the end points of the curve;
 
 ### Linear Bézier curves
 
 ![Linear bézier curves](linear.png)
 ![LinearBézierCurves](LinearBézierCurves.png)
 
 ### Quadratic Bézier curves
 
 ![QuadraticBéziercurves](QuadraticBéziercurves.png)
 ![Quadratic](Quadratic.png)
 
 ### Cubic Bézier curves
 
 ![CubicBéziercurves](CubicBéziercurves.png)
 ![Cubic](Cubic.png)
 
 **Tips:** Moving control points **dots** and see how the curve is generated?
 
 You can change the animation **speed** and the dots **color** by code.
 
 **Enjoy and Learn** 👍👍👍
 
 [Next page](@next), we will see how Bézier curves generalized to higher dimensions to form **Bézier surfaces** 😉.
 
 */
//#-hidden-code
import UIKit
import PlaygroundSupport
let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

var speed = 1.0
var pointColor = UIColor.red

let proxy = page.liveView as! PlaygroundRemoteLiveViewProxy


class MyClassThatListens: PlaygroundRemoteLiveViewProxyDelegate {
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
    }
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        if case let .dictionary(dic) = message {
            guard case let .boolean(success)? = dic["success"] else {
                return
            }
            
            if Bool(success) { //in good mood then success
                page.assessmentStatus = .pass(message: "## Don't forget to check out [**Next Page**](@next), we are going to play with Bézier surface 👏👏🏻👏🏽 ")
            }
        }
    }
}

let listener = MyClassThatListens()
proxy.delegate = listener
//#-end-hidden-code

//#-editable-code
//: **Animation speed**, you can use it to slow down the generation process, like use 0.5.
speed = 1.0
//: Change dots color
pointColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//#-end-editable-code

//#-hidden-code
proxy.send(PlaygroundValue.dictionary(["animationDuration": .floatingPoint(speed)]))
do {
    let myColorData = try NSKeyedArchiver.archivedData(withRootObject: pointColor, requiringSecureCoding: false)
    proxy.send(PlaygroundValue.dictionary(["pointColor": .data(myColorData)]))
} catch {
    
}
//#-end-hidden-code
