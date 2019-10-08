//
//  UITextView.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/3/2.
//

import UIKit

public extension Stem where Base: UITextView {

    /// 占位文本控件
    var placeholderLabel: UILabel {
        if let label = self.ivar(for: "_placeholderLabel") as UILabel? { return label }
        let item = UILabel()
        item.numberOfLines = 0
        item.font = base.font
        item.textColor = UIColor.gray.withAlphaComponent(0.7)
        base.addSubview(item)
        base.setValue(item, forKey: "_placeholderLabel")
        return item
    }

    /// 占位颜色
    var placeholderColor: UIColor {
        set { self.placeholderLabel.textColor = newValue }
        get { return self.placeholderLabel.textColor }
    }

    /// 占位富文本
    var attributedPlaceholder: NSAttributedString? {
        set { self.placeholderLabel.attributedText = newValue }
        get { return self.placeholderLabel.attributedText }
    }

    /// 占位文本
    var placeholder: String? {
        set { self.placeholderLabel.text = newValue }
        get { return self.placeholderLabel.text }
    }

}

public extension Stem where Base: UITextView {

    func convertRange(from textRange: UITextRange) -> NSRange {
        let location = base.offset(from: base.beginningOfDocument, to: textRange.start)
        let length = base.offset(from: textRange.start, to: textRange.end)
        return NSRange(location: location, length: length)
    }

    func convertUITextRange(from range: NSRange) -> UITextRange? {
        if range.location == NSNotFound || NSMaxRange(range) > base.text.count { return nil }
        let beginning = base.beginningOfDocument
        guard
            let startPosition = base.position(from: beginning, offset: range.location),
            let endPosition = base.position(from: beginning, offset: NSMaxRange(range))
            else { return nil }
        return base.textRange(from: startPosition, to: endPosition)
    }

    @discardableResult
    func setTextKeepingSelectedRange(text: String) -> Stem<Base> {
        let selectedTextRange = base.selectedTextRange
        base.text = text
        base.selectedTextRange = selectedTextRange
        return self
    }

    @discardableResult
    func setAttributedTextKeepingSelectedRange(attributedText: NSAttributedString) -> Stem<Base> {
        let selectedTextRange = base.selectedTextRange
        base.attributedText = attributedText
        base.selectedTextRange = selectedTextRange
        return self
    }

    @discardableResult
    func scrollRangeToVisible(range: NSRange) -> Stem<Base> {
        guard !base.bounds.isEmpty, let textRange = convertUITextRange(from: range) else { return self }
        let selectionRects = base.selectionRects(for: textRange)
        var rect = CGRect.zero

        for selectionRect in selectionRects where !selectionRect.rect.isEmpty {
            if rect.isEmpty {
                rect = selectionRect.rect
            } else {
                rect = rect.union(selectionRect.rect)
            }
        }

        guard !rect.isEmpty else { return self }

        rect = base.convert(rect, from: base.textInputView)
        _scrollRectToVisible(rect: rect, animated: true)
        return self
    }

    /// 将光标移动至可视区域
    ///
    /// - Parameter animated: 是否执行动画
    @discardableResult
    func scrollCaretVisible(animated: Bool) -> Stem<Base> {
        guard !base.bounds.isEmpty, let position = base.selectedTextRange?.end else { return self }
        let caretRect = base.caretRect(for: position)
        _scrollRectToVisible(rect: caretRect, animated: animated)
        return self
    }

}

// MARK: - private
private extension Stem where Base: UITextView {

    func _scrollRectToVisible(rect: CGRect, animated: Bool) {
        guard rect.st.isValidated else { return }
        var contentOffsetY = base.contentOffset.y

        if rect.minY == base.contentOffset.y + base.textContainerInset.top {
            // 命中这个条件说明已经不用调整了，直接 return，避免继续走下面的判断，会重复调整，导致光标跳动
            return
        }

        if rect.minY < base.contentOffset.y + base.textContainerInset.top {
            // 光标在可视区域上方，往下滚动
            contentOffsetY = rect.minY - base.textContainerInset.top - base.contentInset.top
        } else if rect.maxY > base.contentOffset.y + base.bounds.height - base.textContainerInset.bottom - base.contentInset.bottom {
            // 光标在可视区域下方，往上滚动
            contentOffsetY = rect.maxY - base.bounds.height + base.textContainerInset.bottom + base.contentInset.bottom

        } else {
            // 光标在可视区域内，不用调整
            return
        }
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: contentOffsetY), animated: animated)
    }

}
