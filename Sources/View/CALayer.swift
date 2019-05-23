//
//  CALayer.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/5/17.
//

import UIKit

public extension Stem where Base: CALayer {

    var inset: UIEdgeInsets? {
        set { base.inset = newValue }
        get { return base.inset }
    }

    func addSublayers(_ layers: CALayer...) {
        layers.forEach({ base.addSublayer($0) })
    }

}


fileprivate extension CALayer {


    struct ActionKey {
        static var inset = UnsafeRawPointer(bitPattern: "CALayer.inset".hashValue)!
    }


    static let swizzing: Void = {
        StemRuntime.exchangeMethod(selector: #selector(CALayer.layoutSublayers),
                                   replace: #selector(CALayer.st_layoutSublayers),
                                   class: CALayer.self)

    }()


    /// 自适应边距布局(针对于父控件)
    var inset: UIEdgeInsets? {
        get { return objc_getAssociatedObject(self, CALayer.ActionKey.inset) as? UIEdgeInsets }
        set {
            CALayer.swizzing
            objc_setAssociatedObject(self,
                                       CALayer.ActionKey.inset,
                                       newValue,
                                       .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func st_layoutSublayers() {
        st_layoutSublayers()
        CALayer().st.inset = .zero
        self.sublayers?.forEach({ (sublayer) in
            if let inset = sublayer.inset{
                sublayer.frame = CGRect(x: inset.left,
                                        y: inset.top,
                                        width: self.bounds.width - inset.left - inset.right,
                                        height: self.bounds.height - inset.top - inset.bottom)
            }
        })
    }
}
