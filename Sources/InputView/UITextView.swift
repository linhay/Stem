//
//  UITextView.swift
//  FBSnapshotTestCase
//
//  Created by linhey on 2019/3/2.
//

import UIKit

extension Stem where Base: UITextView {
  
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
  
  func setTextKeepingSelectedRange(text: String) {
    let selectedTextRange = base.selectedTextRange
    base.text = text
    base.selectedTextRange = selectedTextRange
  }
  
  func setAttributedTextKeepingSelectedRange(attributedText: NSAttributedString) {
    let selectedTextRange = base.selectedTextRange
    base.attributedText = attributedText
    base.selectedTextRange = selectedTextRange
  }
  
  func scrollRangeToVisible(range: NSRange) {
    guard !base.bounds.isEmpty, let textRange = convertUITextRange(from: range) else { return }
    let selectionRects = base.selectionRects(for: textRange)
    var rect = CGRect.zero
    
    for selectionRect in selectionRects {
      if  !selectionRect.rect.isEmpty {
        if rect.isEmpty {
          rect = selectionRect.rect
        }else{
          rect = rect.union(selectionRect.rect)
        }
      }
    }
    
    guard !rect.isEmpty else { return }
    
    rect = base.convert(rect, from: base.textInputView)
    _scrollRectToVisible(rect: rect, animated: true)
  }
  
  /// 将光标移动至可视区域
  ///
  /// - Parameter animated: 是否执行动画
  func scrollCaretVisible(animated: Bool) {
    guard !base.bounds.isEmpty, let position = base.selectedTextRange?.end else { return }
    let caretRect = base.caretRect(for: position)
    _scrollRectToVisible(rect: caretRect, animated: animated)
  }
  
  private func _scrollRectToVisible(rect: CGRect, animated: Bool) {
    guard rect.isValidated else { return }
    var contentOffsetY = base.contentOffset.y
    
    if rect.minY == base.contentOffset.y + base.textContainerInset.top {
      // 命中这个条件说明已经不用调整了，直接 return，避免继续走下面的判断，会重复调整，导致光标跳动
      return
    }
    
    if rect.minY < base.contentOffset.y + base.textContainerInset.top {
      // 光标在可视区域上方，往下滚动
      contentOffsetY = rect.minY - base.textContainerInset.top - base.contentInset.top
    }else if rect.maxY > base.contentOffset.y + base.bounds.height - base.textContainerInset.bottom - base.contentInset.bottom {
      // 光标在可视区域下方，往上滚动
      contentOffsetY = rect.maxY - base.bounds.height + base.textContainerInset.bottom + base.contentInset.bottom
      
    }else{
      // 光标在可视区域内，不用调整
      return
    }
    base.setContentOffset(CGPoint(x: base.contentOffset.x, y: contentOffsetY), animated: animated)
  }
  
}
