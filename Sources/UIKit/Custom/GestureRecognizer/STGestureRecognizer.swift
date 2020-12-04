// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit)
import UIKit

public final class STGestureRecognizer: UIGestureRecognizer {

    public var   startPoint: CGPoint = CGPoint.zero
    public var    lastPoint: CGPoint = CGPoint.zero
    public var currentPoint: CGPoint = CGPoint.zero
    private var actionStore: [State: ((_ gesture: STGestureRecognizer, _ state: State) -> Void)] = [:]

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first, let view = self.view else { return }
        self.state = .began
        startPoint = touch.location(in: view)
        lastPoint = currentPoint
        currentPoint = startPoint
        actionStore[self.state]?(self, self.state)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first, let view = self.view else { return }
        self.state = .changed
        currentPoint = touch.location(in: view)
        lastPoint = currentPoint
        actionStore[self.state]?(self, self.state)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
        actionStore[self.state]?(self, self.state)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .cancelled
        actionStore[self.state]?(self, self.state)
    }

    public func add(for state: State, action: ((_ gesture: STGestureRecognizer, _ state: State) -> Void)?) {
        self.actionStore[state] = action
    }

    public override func reset() {
        self.state = .possible
    }

    public func cancel() {
        if self.state == .began || self.state == .changed {
            self.state = .cancelled
            actionStore[self.state]?(self, self.state)
        }
    }

}
#endif
