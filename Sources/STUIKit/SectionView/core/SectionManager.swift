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

public class SectionManager<SectionView: UIView> {

    public private(set) var sections: [SectionProtocol] = []
    public private(set) unowned var sectionView: SectionView

    var reloadDataEvent: (() -> Void)?
    
    public init(sectionView: SectionView) {
        self.sectionView = sectionView
    }

    public enum Refresh {
        case none
        case reload
        case insert(_: IndexSet)
        case delete(_: IndexSet)
        case move(from: Int, to: Int)
    }

    func pick(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) { }

    func reload() -> Refresh {
        _ = calculator(sections: sections, in: sectionView)
        return .reload
    }

    func update(_ newSections: [SectionProtocol]) -> Refresh {
        unlink(sections)
        sections = calculator(sections: newSections, in: sectionView)
        return .reload
    }

    func delete(at index: Int) -> Refresh {
        if sections.isEmpty || sections.count <= index {
            return .reload
        } else {
            sections = calculator(sections: sections, in: sectionView)
            return .delete(IndexSet([index]))
        }
    }

    func move(from: Int, to: Int) -> Refresh {
        guard from >= 0, to >= 0, sections.count > max(from, to) else {
            return .none
        }
        return .move(from: from, to: to)
    }

    func insert(section: SectionProtocol, at index: Int) -> Refresh {
        guard contains(section: section, in: sections) == false else {
            return .none
        }

        let isEmpty = sections.isEmpty
        if sections.isEmpty || sections.count <= index {
            sections.append(section)
            sections = calculator(sections: sections, in: sectionView)
            return isEmpty ? .reload : .insert(IndexSet([sections.count]))
        } else {
            sections.insert(section, at: index)
            sections = calculator(sections: sections, in: sectionView)
            return .insert(IndexSet([index]))
        }
    }

}

private extension SectionManager {
    
    func unlink(_ sections: [SectionProtocol]) {
        sections.forEach { $0.core = nil }
    }

    func rebase(_ section: SectionProtocol) {
        section.core = SectionCore()
        section.core?.reloadDataEvent = reloadDataEvent
    }

    func contains(section: SectionProtocol, in sections: [SectionProtocol]) -> Bool {
        return sections.contains(where: { $0 === section })
    }

    func calculator(sections: [SectionProtocol], in sectionView: SectionView) -> [SectionProtocol] {
        return sections.enumerated().compactMap { [weak sectionView] index, section in
            guard let sectionView = sectionView else {
                return nil
            }
            rebase(section)
            section.core?.index = index
            section.core?.sectionView = sectionView
            return section
        }
    }

}
#endif
