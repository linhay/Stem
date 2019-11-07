
import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346

extension CIFilter {
    
    convenience init(blur type: Blur) {
        self.init(name: type.rawValue)!
    }
    
    enum Blur: String {
        @available(iOS 9.0, *)
        case boxBlur            = "CIBoxBlur"
        @available(iOS 9.0, *)
        case discBlur           = "CIDiscBlur"
        case gaussianBlur       = "CIGaussianBlur"
        @available(OSX 10.10, *)
        case maskedVariableBlur = "CIMaskedVariableBlur"
        @available(iOS 9.0, *)
        case medianFilter       = "CIMedianFilter"
        @available(iOS 9.0, *)
        case motionBlur         = "CIMotionBlur"
        @available(iOS 9.0, *)
        case noiseReduction     = "CINoiseReduction"
        @available(iOS 9.0, *)
        case zoomReduction     = "CIZoomBlur"
    }
    
}



extension CIFilter.Blur {
    
    @available(iOS 9.0, *)
    public struct BoxBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .boxBlur)

        @CIFilterValueBox var radius: NSNumber

        init() {
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }

    @available(iOS 9.0, *)
    public struct DiscBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(blur: .discBlur)

        @CIFilterValueBox var radius: NSNumber

        init() {
            _radius.cofig(filter: filter, name: "inputRadius", default: 8.00)
        }
    }

    public struct GaussianBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .gaussianBlur)

        @CIFilterValueBox var radius: NSNumber

        init() {
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }

    @available(OSX 10.10, *)
    public struct MaskedVariableBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .maskedVariableBlur)

        @CIFilterValueBox var mask: CIImage?
        @CIFilterValueBox var radius: NSNumber

        init() {
            _radius.cofig(filter: filter, name: "inputRadius", default: 8.00)
            _mask.cofig(filter: filter, name: "inputMask", default: nil)
        }

    }

    @available(iOS 9.0, *)
    public struct MedianFilter: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .medianFilter)
    }

    @available(iOS 9.0, *)
    public struct MotionBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(blur: .motionBlur)

        @CIFilterValueBox var angle: NSNumber
        @CIFilterValueBox var radius: NSNumber

        init() {
            _angle.cofig(filter: filter, name: "inputAngle", default: 20)
            _radius.cofig(filter: filter, name: "inputRadius", default: 0)
        }
    }

    @available(iOS 9.0, *)
    public struct NoiseReduction: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(blur: .noiseReduction)

        @CIFilterValueBox var noiseLevel: NSNumber
        @CIFilterValueBox var sharpness: NSNumber

        init() {
            _noiseLevel.cofig(filter: filter, name: "inputNoiseLevel", default: 0.02)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.40)
        }
    }

    @available(iOS 9.0, *)
    public struct ZoomBlur: CIFilterContainerProtocol, CIFilterInputImageProtocol {
        public var filter: CIFilter = CIFilter(blur: .noiseReduction)

        @CIFilterValueBox var inputCenter: CIVector
        @CIFilterValueBox var amount: NSNumber

        init() {
            _inputCenter.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _amount.cofig(filter: filter, name: "inputAmount", default: 20.00)
        }
    }

}
