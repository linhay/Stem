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

public struct SectionReducer {
    
    struct State {
        
        var types: [SectionDynamicType] = []
        
        func contains(_ type: SectionDynamicType) -> Bool {
            return types.contains { $0 == type }
        }
        
    }
    
    enum InputAction {
        case reload
        case reset(state: State, action: OutputAction)
        case update(types: [SectionDynamicType])
        case insert(types: [SectionDynamicType], at: Int)
        case delete(types: [SectionDynamicType])
        case move(from: SectionDynamicType, to: SectionDynamicType)
    }
    
    enum OutputAction {
        case none
        case reload
        case insert(IndexSet)
        case delete(IndexSet)
        case move(from: Int, to: Int)
    }
    
    struct Environment<SectionView: UIView> {
        
        let weakBox: SectionWeakBox<SectionView>
        var reloadDataEvent: (() -> Void)?
        var sectionView: SectionView {
            guard let view = weakBox.value else {
                assertionFailure("难以置信的情况")
                return SectionView()
            }
            return view
        }
        
        init(sectionView: SectionView, reloadDataEvent: (() -> Void)? = nil) {
            self.weakBox = .init(sectionView)
            self.reloadDataEvent = reloadDataEvent
        }
        
        @MainActor
        func transfer(from: State, to: State) -> State {
            from.types.forEach { $0.section.core = nil }
            to.types.enumerated().forEach { index, section in
                section.section.core = SectionCore()
                section.section.core?.reloadDataEvent = reloadDataEvent
                section.section.core?.index = index
                section.section.core?.sectionView = weakBox.value
            }
            return to
        }
        
    }
    
    var state: State
    
    @MainActor
    mutating func reducer<SectionView>(action: InputAction, environment: Environment<SectionView>) -> OutputAction {
        
        func effect(action: InputAction) -> OutputAction {
            return reducer(action: action, environment: environment)
        }
        
        switch action {
        case .reload:
            return effect(action: .reset(state: state, action: .reload))
        case .reset(let state, let action):
            self.state = environment.transfer(from: self.state, to: state)
            return action
        case .update(let types):
            return effect(action: .reset(state: .init(types: types), action: .reload))
        case .insert(types: let types, at: let index):
            var state = state
            
            if state.types.isEmpty || state.types.count <= index {
                state.types.append(contentsOf: types)
                return effect(action: .reset(state: state, action: .reload))
            }
            
            state.types.insert(contentsOf: types, at: index)
            return effect(action: .reset(state: state, action: .insert(IndexSet(integersIn: index..<index + types.count))))
        case .delete(let types):
            
            var state = state
            var set = IndexSet()
            
            for type in types {
                if let index = state.types.firstIndex(of: type) {
                    set.update(with: index)
                }
            }
            
            for index in set.sorted(by: >) {
                state.types.remove(at: index)
            }
            
            return effect(action: .reset(state: state, action: .delete(set)))
        case .move(let from, let to):
            guard let from = state.types.firstIndex(of: from),
                  let to = state.types.firstIndex(of: to) else {
                      return .none
                  }
            var state = state
            state.types.swapAt(from, to)
            return effect(action: .reset(state: state, action: .move(from: from, to: to)))
        }
    }
    
}
#endif
