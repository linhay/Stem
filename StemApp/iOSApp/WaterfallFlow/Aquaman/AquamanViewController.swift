//
//  AquamanViewController.swift
//  iOSApp
//
//  Created by linhey on 2022/2/14.
//

import UIKit
import Stem

class AquamanMainView: UICollectionView, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        if let childScrollView = otherGestureRecognizer.view as? UIScrollView {
            print("\(childScrollView.contentOffset) -- \(childScrollView.frame) -- \(childScrollView.contentSize)")
            if (childScrollView.contentOffset.y + childScrollView.frame.height) >= childScrollView.contentSize.height {
                return false
            }
        }
        
        return false
//
//        guard let scrollView = gestureRecognizer.view as? UIScrollView else {
//            return false
//        }
//
//
//        let offsetY: CGFloat = 260
//        let contentSize = scrollView.contentSize
//        let targetRect = CGRect(x: 0,
//                                y: offsetY - UIApplication.shared.statusBarFrame.height,
//                                width: contentSize.width,
//                                height: contentSize.height - offsetY)
//
//        let currentPoint = gestureRecognizer.location(in: self)
//        return targetRect.contains(currentPoint)
    }
    
}


class AquamanViewController: UIViewController, UIScrollViewDelegate {
    
    let sectionView = AquamanMainView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var manager = SectionCollectionManager(sectionView: sectionView)
    var observations = Set<NSKeyValueObservation>()
    
    let controller = SingleTypeSectionViewController()

    func randomView() -> UIView {
        let item = UIView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = StemColor.random.convert()
        return item
    }
    
    func randomLayoutView() -> UIView {
        let item = UIView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.backgroundColor = StemColor.random.convert()
        NSLayoutConstraint.activate([item.heightAnchor.constraint(equalToConstant: 200)])
        return item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(sectionView)
        
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sectionView.topAnchor.constraint(equalTo: view.topAnchor),
            self.sectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.sectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.sectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        manager.set(layout: .compositional())
        manager.addObserveScroll(target: self)
        
        let scrollView = controller.aquamanScrollView()
        
        observations.update(with: scrollView.observe(\.contentOffset) { scrollView, changed in
            if self.sectionView.isScrollEnabled {
                scrollView.isScrollEnabled = false
            } else {
                scrollView.isScrollEnabled = scrollView.contentOffset.y < 0
                self.sectionView.isScrollEnabled = scrollView.isScrollEnabled == false
            }
        })
        
        
        let menuSection = AquamanMenuSection()
        menuSection.config(header: .init(view: .view(randomView()), height: .absolute(60)))
        menuSection.config(contents: [
            .init(view: .controller(controller), height: .autoLayout),
            .init(view: .view(randomView()), height: .autoLayout),
            .init(view: .view(randomView()), height: .autoLayout)
        ])
        
        let headerSection = AquamanHeaderSection()
        headerSection.config(model: .init(view: .view(randomView()), height: .absolute(200)))
//        headerSection.config(model: .init(view: .view(randomLayoutView()), height: .autoLayout))
        manager.update(headerSection, menuSection)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= 100 {
            scrollView.isScrollEnabled = false
            controller.aquamanScrollView().isScrollEnabled = scrollView.isScrollEnabled == false
        }
        
    }
    
}

enum HeightProvider {
    case autoLayout
    case absolute(CGFloat)
}

protocol AquamanChildController {
    
    func aquamanScrollView() -> UIScrollView
    
}

enum ViewProvider {
    case controller(UIViewController & AquamanChildController)
    case view(UIView)
}

class AquamanCell: UICollectionViewCell, STViewProtocol, ConfigurableModelProtocol {
    
    struct Model {
        let view: ViewProvider
        let height: HeightProvider
    }
    
    func config(_ model: Model) {
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
        switch model.view {
        case .view(let view):
            view.removeFromSuperview()
            self.contentView.addSubview(view)
            NSLayoutConstraint.activate([
                self.contentView.topAnchor.constraint(equalTo: view.topAnchor),
                self.contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                self.contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            switch model.height {
            case .autoLayout:
                break
            case .absolute(let height):
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: height)])
            }
        case .controller(let controller):
            guard let view = controller.view else {
                return
            }
            view.removeFromSuperview()
            self.contentView.addSubview(controller.view)
            NSLayoutConstraint.activate([
                self.contentView.topAnchor.constraint(equalTo: view.topAnchor),
                self.contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                self.contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            
            switch model.height {
            case .autoLayout:
                break
            case .absolute(let height):
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: height)])
            }
        }
    }
    
}

class AquamanHeaderView: UICollectionReusableView, STViewProtocol, ConfigurableModelProtocol {
    
    struct Model {
        let view: ViewProvider
        let height: HeightProvider
    }
    
    func config(_ model: Model) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        switch model.view {
        case .view(let view):
            view.removeFromSuperview()
            self.addSubview(view)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.topAnchor),
                self.leftAnchor.constraint(equalTo: view.leftAnchor),
                self.rightAnchor.constraint(equalTo: view.rightAnchor),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            switch model.height {
            case .autoLayout:
                break
            case .absolute(let height):
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: height)])
            }
        case .controller(let controller):
            guard let view = controller.view else {
                return
            }
            view.removeFromSuperview()
            self.addSubview(controller.view)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.topAnchor),
                self.leftAnchor.constraint(equalTo: view.leftAnchor),
                self.rightAnchor.constraint(equalTo: view.rightAnchor),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            
            switch model.height {
            case .autoLayout:
                break
            case .absolute(let height):
                NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: height)])
            }
        }
    }
    
}


class AquamanMenuSection: SectionCollectionCompositionalLayoutProtocol, SectionCollectionDriveProtocol {
    
    
    var headerModel: AquamanHeaderView.Model?
    var contentModels: [AquamanCell.Model] = []
    
    func config(header model: AquamanHeaderView.Model?) {
        self.headerModel = model
        reload()
    }
    
    func config(contents model: [AquamanCell.Model]) {
        self.contentModels = model
        reload()
    }
    
    func config(sectionView: UICollectionView) {
        register(AquamanHeaderView.self, for: .custom(SupplementaryElementKind.header.rawValue))
        register(AquamanCell.self)
    }
    
    func supplementaryView(kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        guard let kind = SupplementaryElementKind(rawValue: kind) else { return nil }
        switch kind {
        case .header:
            let view = dequeue(kind: .custom(kind.rawValue)) as AquamanHeaderView
            if let model = headerModel {
                view.config(model)
            }
            return view
        }
    }
    
    func item(at row: Int) -> UICollectionViewCell {
        let item = dequeue(at: row) as AquamanCell
        item.config(contentModels[row])
        return item
    }
    
    var core: SectionCore?
    
    var itemCount: Int { contentModels.count }
    
    enum SupplementaryElementKind: String {
        case header = "supplementary-header"
    }
    
    func compositionalLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        
        let item  = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .fractionalHeight(1)))
        
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .absolute(sectionView.frame.height)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if let model = headerModel {
            let supplementaryItem: NSCollectionLayoutBoundarySupplementaryItem
            switch model.height {
            case .autoLayout:
                supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                                  heightDimension: .estimated(100)),
                                                                                     elementKind: SupplementaryElementKind.header.rawValue,
                                                                                     alignment: .top)
            case .absolute(let height):
                supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                                  heightDimension: .absolute(height)),
                                                                                elementKind: SupplementaryElementKind.header.rawValue,
                                                                                alignment: .top)
            }

            supplementaryItem.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [supplementaryItem]
            section.orthogonalScrollingBehavior = .groupPaging
        }

        section.visibleItemsInvalidationHandler = { (item, point, environment) in
            print("\(point) --- \(environment)")
            print(item.map(\.indexPath))
            print(item.map(\.frame.size))
        }
        return section
    }
    
}


class AquamanHeaderSection: SectionCollectionCompositionalLayoutProtocol, SectionCollectionDriveProtocol {
    
    var model: AquamanCell.Model?
    
    func config(sectionView: UICollectionView) {
        register(AquamanCell.self)
    }

    func config(model: AquamanCell.Model) {
        self.model = model
        reload()
    }
    
    func item(at row: Int) -> UICollectionViewCell {
        let cell = dequeue(at: row) as AquamanCell
        if let model = model {
            cell.config(model)
        }
        return cell
    }

    var core: SectionCore?

    var itemCount: Int { model == nil ? 0 : 1 }
    
    func compositionalLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard let model = model else { return nil }

        switch model.height {
        case .autoLayout:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .estimated(500)))
            return NSCollectionLayoutSection(group: .vertical(layoutSize: item.layoutSize, subitems: [item]))
        case .absolute(let height):
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                           heightDimension: .absolute(height)),
                                                         subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
    }
    
}
