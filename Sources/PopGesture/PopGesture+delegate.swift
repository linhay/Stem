//
//  PopGesture+delegate.swift
//  Pods-PopGesture_Example
//
//  Created by linhey on 2018/1/18.
//

import UIKit

class PopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {

  weak var navigationController: UINavigationController?

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
    guard let nav = navigationController else { return false }

    if nav.viewControllers.count <= 1 { return false }
    guard let topViewController = nav.topViewController else { return false }
    if nav.viewControllers.last?.st.popGestureDisabled ?? false { return false }

    let beginningLocation = gestureRecognizer.location(in: gestureRecognizer.view)
    let maxAllowedInitialDistance = topViewController.st.popGestureMaxLeftEdge
    if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance { return false }
    let isTransitioning: Bool = nav.st.ivar(for: "_isTransitioning") ?? false
    if isTransitioning { return false }

    let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
    if translation.x <= 0 { return false }

    return true
  }
}
