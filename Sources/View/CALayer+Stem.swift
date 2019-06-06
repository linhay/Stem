//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

public extension Stem where Base: CALayer {

    var inset: UIEdgeInsets? {
        set { base.inset = newValue }
        get { return base.inset }
    }

    func addSublayers(_ layers: CALayer...) {
        layers.forEach({ base.addSublayer($0) })
    }

    /** 获取视图显示内容

     示例:

     ```
     UIImageView(image: CALayer().st.snapshot)
     ```
     */
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
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
