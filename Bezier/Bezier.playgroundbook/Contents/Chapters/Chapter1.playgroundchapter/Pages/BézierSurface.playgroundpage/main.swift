/*:
 ## Hello, Again
 
 In this page we are going to play with **Bézier surface** 😆
 
 ### Fun
 Try to **tap and move** in the 'smile' surface, see what's happing. 😉
 
 ### Right Back
 
 * Callout(Bézier patch meshes):
 As with the Bézier curve, a Bézier surface is defined by a set of control points.
 Similar to interpolation in many respects, **a key difference** is that the surface **does not**, in general, pass through the central control points.
 Rather, it is "stretched" toward them as though each were an attractive force.
 
 ![Bézier_surface_example](Bézier_surface_example.png)
 
 
 **Enjoy and Learn** 👍👍👍
 
 **Tips** Click the play button, and play with it.
 
 */

//#-hidden-code
import UIKit
import PlaygroundSupport
let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

var kMeshCountPerside: Int = 40

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
                
            }
        }
    }
}

let listener = MyClassThatListens()
proxy.delegate = listener
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-editable-code
//: **mesh count perside**
kMeshCountPerside = 40
//#-end-editable-code

//#-hidden-code
proxy.send(PlaygroundValue.dictionary(["kMeshCountPerside": .integer(kMeshCountPerside)]))
//#-end-hidden-code

