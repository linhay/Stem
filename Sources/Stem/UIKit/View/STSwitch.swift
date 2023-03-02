//
//  CustomSwitch.swift
//  CustomSwitch
//
//  Created by Ivan Kovacevic on 15/12/2016.
//  Copyright © 2016 Ivan Kovacevic. All rights reserved.
//

#if canImport(UIKit) && canImport(Combine)
import UIKit
import Combine

@available(iOS 13.0, *)
public class STSwitch: UIControl {
    
    public private(set) lazy var valueChanged = valueChangedSubject.removeDuplicates().eraseToAnyPublisher()
    private lazy var valueChangedSubject = CurrentValueSubject<Bool, Never>(false)
    
    private(set) public var isOn: Bool {
        set { valueChangedSubject.send(newValue) }
        get { valueChangedSubject.value }
    }
    
    public struct Store {
        public var image: UIImage?
        public var tintColor: UIColor
    }
    
    public struct Shadow {
        public let color: UIColor
        public let offset: CGSize
        public let radius: CGFloat
        public let opacity: Float
    }
    
    public struct ThumbConfiguration {
        public var image: UIImage?
        public var tintColor: UIColor = .white
        public var cornerRadius: CGFloat = 0.5
        public var size = CGSize.zero
        public var shadow: Shadow?
    }
    
    public struct Configuration {
        public var on  = Store(tintColor: UIColor(red: 144.0 / 255, green: 202/255, blue: 119/255, alpha: 1))
        public var off = Store(tintColor: .black)
        public var thumb = ThumbConfiguration()
        public var padding: CGFloat = 1
        public var animationDuration = 0.5
        public var cornerRadius: CGFloat = 0.5
    }
    
    public var store: Store { isOn ? configuration.on : configuration.off }
    
    public var configuration: Configuration = .init() {
        didSet {
            self.setupUI()
            self.layoutSubviews()
        }
    }
    
    // labels
    
    public lazy var labelOff = UILabel()
    public lazy var labelOn  = UILabel()
    
    public lazy var areLabelsShown: Bool = false {
        didSet {
            self.setupUI()
        }
    }
    
    // MARK: Private properties
    private lazy var thumbView    = ThumbView(frame: CGRect.zero)
    private lazy var onImageView  = UIImageView(frame: CGRect.zero)
    private lazy var offImageView = UIImageView(frame: CGRect.zero)
    
    private lazy var onPoint = CGPoint.zero
    private lazy var offPoint = CGPoint.zero
    private lazy var isAnimating = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
}

// MARK: Private methods
@available(iOS 13.0, *)
private extension STSwitch {
    
    func setupUI() {
        // clear self before configuration
        self.clear()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        onImageView.image = configuration.on.image
        offImageView.image = configuration.off.image
        thumbView.backgroundColor = configuration.thumb.tintColor
        thumbView.imageView.image = configuration.thumb.image
        thumbView.isUserInteractionEnabled = false
        
        thumbView.layer.shadowColor   = configuration.thumb.shadow?.color.cgColor
        thumbView.layer.shadowOffset  = configuration.thumb.shadow?.offset  ?? .zero
        thumbView.layer.shadowRadius  = configuration.thumb.shadow?.radius  ?? .zero
        thumbView.layer.shadowOpacity = configuration.thumb.shadow?.opacity ?? .zero
        
        backgroundColor = store.tintColor
        
        addSubview(self.thumbView)
        addSubview(self.onImageView)
        addSubview(self.offImageView)
        
        setupLabels()
    }
    
    func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setOn(on: Bool, animated: Bool) {
        switch animated {
        case true:
            self.animate(on: on)
        case false:
            self.isOn = on
            self.setupViewsOnAction()
            self.completeAction()
        }
    }
    
    func animate(on:Bool? = nil) {
        self.isOn = on ?? !self.isOn
        self.isAnimating = true
        
        UIView.animate(withDuration: configuration.animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [UIView.AnimationOptions.curveEaseInOut,
                                 UIView.AnimationOptions.beginFromCurrentState,
                                 UIView.AnimationOptions.allowUserInteraction], animations: {
            self.setupViewsOnAction()
        }, completion: { _ in
            self.completeAction()
        })
    }
    
    private func setupViewsOnAction() {
        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
        self.backgroundColor = store.tintColor
        self.setOnOffImageFrame()
        
    }
    
    private func completeAction() {
        self.isAnimating = false
        self.sendActions(for: UIControl.Event.valueChanged)
    }
}

// Mark: Public methods
@available(iOS 13.0, *)
extension STSwitch {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !self.isAnimating else {
            return
        }
        self.layer.cornerRadius = self.bounds.size.height * min(max(configuration.cornerRadius, 0.5), 0.5)
        self.backgroundColor = store.tintColor
        
        // thumb managment
        // get thumb size, if none set, use one from bounds
        let thumbSize = configuration.thumb.size != .zero ? configuration.thumb.size : CGSize(width: self.bounds.size.height - 2, height: self.bounds.height - 2)
        let yPostition = (self.bounds.size.height - thumbSize.height) / 2
        
        self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - configuration.padding, y: yPostition)
        self.offPoint = CGPoint(x: configuration.padding, y: yPostition)
        
        self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
        self.thumbView.layer.cornerRadius = thumbSize.height * min(max(configuration.thumb.cornerRadius, 0.5), 0.5)
        
        
        //label frame
        if self.areLabelsShown {
            
            let labelWidth = self.bounds.width / 2 - configuration.padding * 2
            self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
            self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
            
        }
        
        // on/off images
        //set to preserve aspect ratio of image in thumbView
        
        guard configuration.on.image != nil,
              configuration.off.image != nil else {
            return
        }
        
        let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
        
        let onOffImageSize = CGSize(width: frameSize, height: frameSize)
        
        
        self.onImageView.frame.size = onOffImageSize
        self.offImageView.frame.size = onOffImageSize
        
        self.onImageView.center = CGPoint(x: self.onPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
        self.offImageView.center = CGPoint(x: self.offPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
        
        
        self.onImageView.alpha = self.isOn ? 1.0 : 0.0
        self.offImageView.alpha = self.isOn ? 0.0 : 1.0
    }
}

//Mark: Labels frame
@available(iOS 13.0, *)
extension STSwitch {
    
    private func setupLabels() {
        guard self.areLabelsShown else {
            self.labelOff.alpha = 0
            self.labelOn.alpha = 0
            return
            
        }
        
        self.labelOff.alpha = 1
        self.labelOn.alpha = 1
        
        let labelWidth = self.bounds.width / 2 - configuration.padding * 2
        self.labelOn.frame  = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOn.font  = UIFont.boldSystemFont(ofSize: 12)
        self.labelOff.font = UIFont.boldSystemFont(ofSize: 12)
        self.labelOn.textColor  = UIColor.white
        self.labelOff.textColor = UIColor.white
        
        self.labelOff.sizeToFit()
        self.labelOff.text = "Off"
        self.labelOn.text = "On"
        self.labelOff.textAlignment = .center
        self.labelOn.textAlignment = .center
        
        self.insertSubview(self.labelOff, belowSubview: self.thumbView)
        self.insertSubview(self.labelOn, belowSubview: self.thumbView)
    }
    
}

//Mark: Animating on/off images
@available(iOS 13.0, *)
extension STSwitch {
    
    private func setOnOffImageFrame() {
        guard configuration.on.image != nil,
              configuration.off.image != nil else {
            return
        }
        
        self.onImageView.center.x = self.isOn ? self.onPoint.x + self.thumbView.frame.size.width / 2 : self.frame.width
        self.offImageView.center.x = !self.isOn ? self.offPoint.x + self.thumbView.frame.size.width / 2 : 0
        self.onImageView.alpha = self.isOn ? 1.0 : 0.0
        self.offImageView.alpha = self.isOn ? 0.0 : 1.0
        
    }
}


@available(iOS 13.0, *)
public extension STSwitch {
    
    final class ThumbView: UIView {
        
        public var imageView = UIImageView(frame: CGRect.zero)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(self.imageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.addSubview(self.imageView)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.imageView.layer.cornerRadius = self.layer.cornerRadius
            self.imageView.clipsToBounds = self.clipsToBounds
        }
        
    }
    
}
#endif
