//
//  EmptyViewController.swift
//  iOSApp
//
//  Created by 林翰 on 2021/3/26.
//

import UIKit
import Stem

class FigmaView: UIView {
    
    init(frame: CGRect, _ views: [FigmaView] = []) {
        super.init(frame: frame)
        backgroundColor = StemColor.random.convert()
        let color: UIColor = StemColor.random.convert()
        views.forEach {
            $0.backgroundColor = color
            self.addSubview($0)
        }
    }
    
    init(frame: CGRect, rects: [CGRect]) {
        super.init(frame: frame)
        backgroundColor = StemColor.random.convert()
        let color: UIColor = StemColor.random.convert()
        rects.forEach {
            let item = FigmaView(frame: $0)
            item.backgroundColor = color
            self.addSubview(item)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FigmaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let node = FigmaView(frame: CGRect(x: 0, y: 0, width: 750, height: 270), [
            FigmaView(frame: CGRect(x: 0, y: 1, width: 750, height: 269), [
                FigmaView(frame: CGRect(x: 40, y: 197, width: 670, height: 32), [
                    FigmaView(frame: CGRect(x: 0, y: 0, width: 212, height: 32)),
                    FigmaView(frame: CGRect(x: 235, y: 1, width: 257, height: 30)),
                    FigmaView(frame: CGRect(x: 537, y: 0, width: 133, height: 32))
                ]),
                FigmaView(frame: CGRect(x: 40, y: 267, width: 670, height: 2)),
                FigmaView(frame: CGRect(x: 41, y: 40, width: 669, height: 45)),
                FigmaView(frame: CGRect(x: 41, y: 101, width: 669, height: 78))
            ]),
            FigmaView(frame: CGRect(x: 40, y: 0, width: 670, height: 1))
        ])
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(node)
    }
    
}
