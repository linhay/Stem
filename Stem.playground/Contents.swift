//: Playground - noun: a place where people can play

import UIKit
import AVKit
import PlaygroundSupport


let v1 = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
v1.backgroundColor = .yellow

let v2 = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
v2.backgroundColor = .red

PlaygroundPage.current.liveView = v1
PlaygroundPage.current.needsIndefiniteExecution = true

UIView.transition(with: v1, duration: 3, options: .curveEaseOut, animations: {
    v1.addSubview(v2)
}, completion: nil)

UIView.animate(withDuration: 10) {
    v1.frame.size.width += 200
    v1.backgroundColor = UIColor.red
}
