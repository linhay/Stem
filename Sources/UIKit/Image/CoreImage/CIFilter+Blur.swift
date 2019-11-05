
import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346

extension CIFilter {
    
    convenience init(blur type: Blur) {
        self.init(name: type.rawValue)!
    }
    
    enum Blur: String, CaseIterable {
        @available(OSX 10.5, *) @available(iOS 9.0, *)
        case boxBlur            = "CIBoxBlur"
        @available(OSX 10.5, *) @available(iOS 9.0, *)
        case discBlur           = "CIDiscBlur"
        @available(OSX 10.4, *) @available(iOS 6.0, *)
        case gaussianBlur       = "CIGaussianBlur"
        @available(OSX 10.10, *)
        case maskedVariableBlur = "CIMaskedVariableBlur"
        @available(OSX 10.4, *) @available(iOS 9.0, *)
        case medianFilter       = "CIMedianFilter"
        @available(OSX 10.4, *) @available(iOS 9.0, *)
        case motionBlur         = "CIMotionBlur"
        @available(OSX 10.4, *) @available(iOS 9.0, *)
        case noiseReduction     = "CINoiseReduction"
        @available(OSX 10.4, *) @available(iOS 9.0, *)
        case zoomReduction     = "CIZoomBlur"
    }
    
}

extension CIFilter.Blur {
    
    @available(OSX 10.5, *) @available(iOS 9.0, *)
    public struct BoxBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterInputRadiusProtocol {
        public var filter: CIFilter = CIFilter(blur: .boxBlur)
    }
    
    @available(OSX 10.5, *) @available(iOS 9.0, *)
    public struct DiscBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterInputRadiusProtocol {
        public var filter: CIFilter = CIFilter(blur: .discBlur)
    }
    
    @available(OSX 10.4, *) @available(iOS 6.0, *)
    public struct GaussianBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterInputRadiusProtocol {
        public var filter: CIFilter = CIFilter(blur: .gaussianBlur)
    }
    
    @available(OSX 10.10, *)
    public struct MaskedVariableBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterInputRadiusProtocol {
        public var filter: CIFilter = CIFilter(blur: .maskedVariableBlur)
        
        var image: CIImage? {
            set { filter.setValue(newValue, forKey: "inputMask") }
            get { return filter.value(forKey: "inputMask") as? CIImage }
        }
    }
    
    @available(OSX 10.4, *) @available(iOS 9.0, *)
    public struct MedianFilter: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .medianFilter)
    }
    
    @available(OSX 10.4, *) @available(iOS 9.0, *)
    public struct MotionBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterInputRadiusProtocol, CIFilterValueProtocol {
        public var filter: CIFilter = CIFilter(blur: .motionBlur)
        
        var angle: NSNumber {
            set { set(number: newValue, for: "inputAngle") }
            get { return number(for: "inputAngle") }
        }
    }
    
    @available(OSX 10.4, *) @available(iOS 9.0, *)
    public struct NoiseReduction: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {
        public var filter: CIFilter = CIFilter(blur: .noiseReduction)
        
        var noiseLevel: NSNumber {
            set { set(number: newValue, for: "inputNoiseLevel") }
            get { return number(for: "inputNoiseLevel") }
        }
        
        var sharpness: NSNumber {
            set { set(number: newValue, for: "inputSharpness") }
            get { return number(for: "inputSharpness") }
        }
    }
    
    @available(OSX 10.4, *) @available(iOS 9.0, *)
    public struct ZoomBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {
        public var filter: CIFilter = CIFilter(blur: .noiseReduction)
        
        var inputCenter: CIVector {
            set { set(vector: newValue, for: "inputCenter") }
            get { return vector2(for: "inputCenter") }
        }
        
        var amount: NSNumber {
            set { set(number: newValue, for: "inputAmount") }
            get { return number(for: "inputAmount") }
        }
    }
    
}
