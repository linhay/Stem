//
//  ViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/8/3.
//  Copyright © 2020 linhey.ax. All rights reserved.
//

import UIKit

class SectionRowCore {
    var indexPath: IndexPath = IndexPath()
    var sectionView: UIView?
    internal init() { }
}

protocol SectionCoreProtocol {
    
    var rowCore: SectionRowCore? { get }
    
}

protocol SectionRowDelegateProtocol: SectionCoreProtocol {
    /// UICollectionViewDelegate & UITableViewDelegate
    var shouldSelect: Bool { get }
    func selected()
    
    var shouldDeselect: Bool { get }
    func deselected()
    
    /// MultipleSelectionInteraction
    var shouldBeginMultipleSelectionInteraction: Bool { get }
    func didBeginMultipleSelectionInteraction()
    func didEndMultipleSelectionInteraction()
    
    /// Managing Cell Highlighting
    var shouldHighlight: Bool { get }
    func highlighted()
    func unhighlighted()

    /// Tracking the Addition and Removal of Views
    func willDisplay()
    func didEndDisplay()
    
    /// Editing Items
    var canEdit: Bool { get }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
