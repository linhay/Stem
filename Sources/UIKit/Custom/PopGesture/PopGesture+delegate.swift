//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE



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
    let isTransitioning: Bool = nav.st.value(for: "_isTransitioning") ?? false
    if isTransitioning { return false }

    let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
    if translation.x <= 0 { return false }

    return true
  }
}
