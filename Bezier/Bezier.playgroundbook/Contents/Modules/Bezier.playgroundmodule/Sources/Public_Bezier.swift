//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.

public func instantiateViewController() -> PlaygroundLiveViewable {
    return ViewController()
}

public func instantiateMeshVC() -> PlaygroundLiveViewable {
    return MeshVC()
}

public func instantiateRevolutionVC() -> PlaygroundLiveViewable {
    return RevolutionVC()
}

//public func instantiateARVC() -> PlaygroundLiveViewable {
//    return ARViewController()
//}



