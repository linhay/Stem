//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Stem


class MyViewController : UIViewController {


    func setTag(string: NSAttributedString,
                edgeInsets: UIEdgeInsets,
                backgroundColor: UIColor) -> NSAttributedString {
        let textLayer = CATextLayer()

        string.st.set
            .strikethroughStyle(.patternDash)
            .strikethroughColor(.blue)
            .baselineOffset(0)

        let size = string.boundingRect(with: CGSize.max, options: [], context: nil).size

        textLayer.string = string
        textLayer.frame = CGRect(x: edgeInsets.left,
                                 y: edgeInsets.top,
                                 width: size.width,
                                 height: size.height)

        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = .center

        textLayer.backgroundColor = UIColor.green.cgColor

        let bglayer = CALayer()
        bglayer.st.set
            .frame(CGRect(x: 0,
                          y: 0,
                          width: textLayer.frame.width + edgeInsets.left + edgeInsets.right,
                          height: textLayer.frame.height + edgeInsets.top + edgeInsets.bottom))
            .backgroundColor(backgroundColor.cgColor)
            .cornerRadius(3)
            .addSublayer(textLayer)


        let attach = NSTextAttachment()
        attach.image  = bglayer.st.snapshot
        attach.bounds = bglayer.bounds

        return NSAttributedString(attachment: attach)
    }

    override func loadView() {
        let view = UILabel()
        view.attributedText = setTag(string: NSAttributedString(string: "库存紧张",
                                                                attributes: [.font(UIFont.systemFont(ofSize: 30)),
                                                                             .foregroundColor(UIColor.white)]),
                                     edgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                                     backgroundColor: UIColor(sRGB: 255, g: 60, b: 80)) + setTag(string: NSAttributedString(string: "库存紧张",
                                                                                                                            attributes: [.font(UIFont.systemFont(ofSize: 30)),
                                                                                                                                         .foregroundColor(UIColor.white)]),
                                                                                                 edgeInsets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                                                                                                 backgroundColor: UIColor(sRGB: 255, g: 60, b: 80))

        self.view = view
    }
}

PlaygroundPage.current.liveView = MyViewController()



