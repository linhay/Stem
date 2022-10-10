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
import Foundation
import UIKit

/// A light-weight UITextView subclass that adds support for placeholder.
open class STTextView: UITextView {
    
    // MARK: - Private Properties
    
    private var placeholderAttributes: [NSAttributedString.Key: Any] {
        var placeholderAttributes = self.typingAttributes
        if placeholderAttributes[.font] == nil {
            placeholderAttributes[.font] = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        if placeholderAttributes[.paragraphStyle] == nil {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode
            placeholderAttributes[.paragraphStyle] = paragraphStyle
        }
        
        placeholderAttributes[.foregroundColor] = self.placeholderColor
        
        return placeholderAttributes
    }
    
    private var placeholderInsets: UIEdgeInsets {
        
        let placeholderInsets = UIEdgeInsets(top: self.contentInset.top + self.textContainerInset.top,
                                             left: self.contentInset.left + self.textContainerInset.left,
                                             bottom: self.contentInset.bottom + self.textContainerInset.bottom,
                                             right: self.contentInset.right + self.textContainerInset.right)
        return placeholderInsets
    }
    
    private lazy var placeholderLayoutManager = NSLayoutManager()
    private lazy var placeholderTextContainer = NSTextContainer()
    
    // MARK: - Open Properties
    
    /// The attributed string that is displayed when there is no other text in the placeholder text view. This value is `nil` by default.
    @NSCopying open var attributedPlaceholder: NSAttributedString? {
        didSet {
            guard self.attributedPlaceholder != oldValue else {
                return
            }
            if let attributedPlaceholder = self.attributedPlaceholder {
                let attributes = attributedPlaceholder.attributes(at: 0, effectiveRange: nil)
                if let font = attributes[.font] as? UIFont,
                   self.font != font {
                    
                    self.font = font
                    self.typingAttributes[.font] = font
                }
                if let foregroundColor = attributes[.foregroundColor] as? UIColor,
                   self.placeholderColor != foregroundColor {
                    
                    self.placeholderColor = foregroundColor
                }
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle,
                   self.textAlignment != paragraphStyle.alignment {
                    
                    let mutableParagraphStyle = NSMutableParagraphStyle()
                    mutableParagraphStyle.setParagraphStyle(paragraphStyle)
                    
                    self.textAlignment = paragraphStyle.alignment
                    self.typingAttributes[.paragraphStyle] = mutableParagraphStyle
                }
            }
            guard self.isEmpty == true else {
                return
            }
            self.setNeedsDisplay()
        }
    }
    
    /// Determines whether or not the placeholder text view contains text.
    open var isEmpty: Bool { return self.text.isEmpty }
    
    /// The string that is displayed when there is no other text in the placeholder text view. This value is `nil` by default.
    open var placeholder: String? {
        get { self.attributedPlaceholder?.string }
        set {
            if let newValue = newValue {
                self.attributedPlaceholder = NSAttributedString(string: newValue, attributes: self.placeholderAttributes)
            }
            else {
                self.attributedPlaceholder = nil
            }
        }
    }
    
    /// The color of the placeholder. This property applies to the entire placeholder string. The default placeholder color is `UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)`.
    open var placeholderColor: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) {
        didSet {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    // MARK: - Superclass Properties
    
    open override var attributedText: NSAttributedString! { didSet { self.setNeedsDisplay() } }
    
    open override var bounds: CGRect { didSet { self.setNeedsDisplay() } }
    
    open override var contentInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }
    
    open override var font: UIFont? {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    open override var textContainerInset: UIEdgeInsets { didSet { self.setNeedsDisplay() } }
    
    open override var typingAttributes: [NSAttributedString.Key: Any] {
        
        didSet {
            
            if let placeholder = self.placeholder as String? {
                
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: self.placeholderAttributes)
            }
        }
    }
    
    // MARK: - Object Lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitializer()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInitializer()
    }
    
    // MARK: - Superclass API
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        
        guard self.text.isEmpty == true,
              let attributedPlaceholder = self.attributedPlaceholder,
              attributedPlaceholder.length > 0 else {
            
            return super.caretRect(for: position)
        }
        
        var caretRect = super.caretRect(for: position)
        
        let placeholderLineFragmentUsedRect = self.placeholderLineFragmentUsedRectForGlyphAt0GlyphIndex(attributedPlaceholder: attributedPlaceholder)
        
        let userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection
        if #available(iOS 10.0, *) {
            
            userInterfaceLayoutDirection = self.effectiveUserInterfaceLayoutDirection
        }
        else {
            
            userInterfaceLayoutDirection = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
        }
        
        let placeholderInsets = self.placeholderInsets
        switch userInterfaceLayoutDirection {
            
        case .rightToLeft:
            caretRect.origin.x = placeholderInsets.left + placeholderLineFragmentUsedRect.maxX - self.textContainer.lineFragmentPadding
            
        case .leftToRight:
            fallthrough
            
        @unknown default:
            caretRect.origin.x = placeholderInsets.left + placeholderLineFragmentUsedRect.minX + self.textContainer.lineFragmentPadding
        }
        
        return caretRect
    }
    
    open override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard self.isEmpty == true else {
            
            return
        }
        
        guard let attributedPlaceholder = self.attributedPlaceholder else {
            
            return
        }
        
        var inset = self.placeholderInsets
        inset.left += self.textContainer.lineFragmentPadding
        inset.right += self.textContainer.lineFragmentPadding
        
        let placeholderRect = rect.inset(by: inset)
        
        attributedPlaceholder.draw(in: placeholderRect)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if self.isEmpty == true,
           let attributedPlaceholder = self.attributedPlaceholder,
           attributedPlaceholder.length > 0 {
            
            let placeholderInsets = self.placeholderInsets
            
            var textContainerSize = size
            textContainerSize.width -= placeholderInsets.left + placeholderInsets.right
            textContainerSize.height -= placeholderInsets.top + placeholderInsets.bottom
            
            let placeholderUsedRect = self.placeholderUsedRect(
                
                attributedPlaceholder: attributedPlaceholder,
                textContainerSize: textContainerSize
            )
            
            let size = CGSize(
                
                width: ceil(placeholderInsets.left + placeholderUsedRect.maxX + placeholderInsets.right),
                height: ceil(placeholderInsets.top + placeholderUsedRect.maxY + placeholderInsets.bottom)
            )
            return size
        }
        else {
            
            return super.sizeThatFits(size)
        }
    }
    
    open override func sizeToFit() {
        
        if self.isEmpty == true,
           let attributedPlaceholder = self.attributedPlaceholder,
           attributedPlaceholder.length > 0 {
            
            let placeholderUsedRect = self.placeholderUsedRect(
                
                attributedPlaceholder: attributedPlaceholder,
                textContainerSize: .zero
            )
            
            let placeholderInsets = self.placeholderInsets
            self.bounds.size = CGSize(
                
                width: ceil(placeholderInsets.left + placeholderUsedRect.maxX + placeholderInsets.right),
                height: ceil(placeholderInsets.top + placeholderUsedRect.maxY + placeholderInsets.bottom)
            )
        }
        else {
            
            return super.sizeToFit()
        }
    }
    
    // MARK: - Private API
    
    private func commonInitializer() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        contentMode = .topLeft
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextViewTextDidChangeNotification(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    @objc func handleTextViewTextDidChangeNotification(_ notification: Notification) {
        guard let object = notification.object as? Self, object === self else {
            return
        }
        self.setNeedsDisplay()
    }
    
    private func placeholderLineFragmentUsedRectForGlyphAt0GlyphIndex(attributedPlaceholder: NSAttributedString) -> CGRect {
        
        if self.placeholderTextContainer.layoutManager == nil {
            
            self.placeholderLayoutManager.addTextContainer(self.placeholderTextContainer)
        }
        
        let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
        placeholderTextStorage.addLayoutManager(self.placeholderLayoutManager)
        
        self.placeholderTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeholderTextContainer.size = self.textContainer.size
        
        self.placeholderLayoutManager.ensureLayout(for: self.placeholderTextContainer)
        
        return self.placeholderLayoutManager.lineFragmentUsedRect(forGlyphAt: 0, effectiveRange: nil, withoutAdditionalLayout: true)
    }
    
    private func placeholderUsedRect(attributedPlaceholder: NSAttributedString, textContainerSize: CGSize) -> CGRect {
        
        if self.placeholderTextContainer.layoutManager == nil {
            
            self.placeholderLayoutManager.addTextContainer(self.placeholderTextContainer)
        }
        
        let placeholderTextStorage = NSTextStorage(attributedString: attributedPlaceholder)
        placeholderTextStorage.addLayoutManager(self.placeholderLayoutManager)
        
        self.placeholderTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        self.placeholderTextContainer.size = textContainerSize
        
        self.placeholderLayoutManager.ensureLayout(for: self.placeholderTextContainer)
        
        return self.placeholderLayoutManager.usedRect(for: self.placeholderTextContainer)
    }
}
#endif
