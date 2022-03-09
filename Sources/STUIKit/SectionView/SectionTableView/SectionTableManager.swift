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

public class SectionTableManager: SectionScrollManager {

    private var environment: SectionReducer.Environment<UITableView>
    private var reducer = SectionReducer(state: .init())
        
    var sectionView: UITableView { environment.sectionView }
    public var sections: LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazySequence<[SectionDynamicType]>.Elements, SectionTableProtocol?>>, SectionTableProtocol> { reducer.state.types.lazy.compactMap({ $0.section as? SectionTableProtocol }) }

    
    public init(sectionView: UITableView) {
        environment = .init(sectionView: sectionView)
        super.init()
        sectionView.delegate = self
        sectionView.dataSource = self
    }

}

private extension SectionTableManager {

    func operational(_ refresh: SectionReducer.OutputAction, with animation: UITableView.RowAnimation) {
        switch refresh {
        case .none:
            break
        case .reload:
            sectionView.reloadData()
        case .insert(let indexSet):
            sectionView.insertSections(indexSet, with: animation)
        case .delete(let indexSet):
            sectionView.deleteSections(indexSet, with: animation)
        case .move(from: let from, to: let to):
            sectionView.moveSection(from, toSection: to)
        }
    }

}

public extension SectionTableManager {

    func reload() {
        operational(reducer.reducer(action: .reload, environment: environment), with: .none)
    }

    func update(_ sections: SectionTableProtocol..., with animation: UITableView.RowAnimation = .none) {
        update(sections, with: animation)
    }

    func update(_ sections: [SectionTableProtocol], with animation: UITableView.RowAnimation = .none) {
        let update = reducer.reducer(action: .update(types: sections.map({ .section($0) })), environment: environment)
        sections.forEach({ $0.config(sectionView: sectionView) })
        operational(update, with: animation)
    }

    func insert(_ sections: [SectionTableProtocol], at index: Int, with animation: UITableView.RowAnimation = .none) {
        let insert = reducer.reducer(action: .insert(types: sections.map({ .section($0) }), at: index), environment: environment)
        sections.forEach({ $0.config(sectionView: sectionView) })
        operational(insert, with: animation)
    }

    func delete(_ sections: [SectionTableProtocol], with animation: UITableView.RowAnimation = .none) {
        operational(reducer.reducer(action: .delete(types: sections.map({ .section($0) })), environment: environment), with: animation)
    }

    func move(from: SectionTableProtocol, to: SectionTableProtocol, with animation: UITableView.RowAnimation = .none) {
        operational(reducer.reducer(action: .move(from: .section(from), to: .section(to)), environment: environment), with: animation)
    }

}

// MARK: - UITableViewDataSource
extension SectionTableManager: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].item(at: indexPath.item)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].canEditItem(at: indexPath.item)
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].canMove(at: indexPath.item)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        } else {
            sections[sourceIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
            sections[destinationIndexPath.section].move(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension SectionTableManager: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectItem(at: indexPath.item)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].itemHeight(at: indexPath.item)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: sections[indexPath.section].leadingSwipeActions(at: indexPath.item))
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: sections[indexPath.section].trailingSwipeActions(at: indexPath.item))
    }
}
#endif
