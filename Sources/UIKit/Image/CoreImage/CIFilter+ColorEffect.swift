
import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
public extension CIFilter {

    convenience init(colorAdjustment type: ColorEffect) {
        self.init(name: type.rawValue)!
    }

    enum ColorEffect: String, CaseIterable {
        public typealias AllCases = String
        @available(OSX 10.9, *) @available(iOS 7.0, *)
        case colorCrossPolynomial    = "CIColorCrossPolynomial"
        case colorCube               = "CIColorCube"
        case colorCubeWithColorSpace = "CIColorCubeWithColorSpace"
        case colorInvert             = "CIColorInvert"
        case colorMap                = "CIColorMap"
        case colorMonochrome         = "CIColorMonochrome"
        case colorPosterize          = "CIColorPosterize"
        case falseColor              = "CIFalseColor"
        case maskToAlpha             = "CIMaskToAlpha"
        case maximumComponent        = "CIMaximumComponent"
        case minimumComponent        = "CIMinimumComponent"
        case photoEffectChrome       = "CIPhotoEffectChrome"
        case photoEffectFade         = "CIPhotoEffectFade"
        case photoEffectInstant      = "CIPhotoEffectInstant"
        case photoEffectMono         = "CIPhotoEffectMono"
        case photoEffectNoir         = "CIPhotoEffectNoir"
        case photoEffectProcess      = "CIPhotoEffectProcess"
        case photoEffectTonal        = "CIPhotoEffectTonal"
        case photoEffectTransfer     = "CIPhotoEffectTransfer"
        case sepiaTone               = "CISepiaTone"
        case vignette                = "CIVignette"
        case vignetteEffect          = "CIVignetteEffect"
    }

}

extension CIFilter.ColorEffect {

    @available(OSX 10.9, *) @available(iOS 7.0, *)
    public struct ColorCrossPolynomial: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorCrossPolynomial)

        var redCoefficients: CIVector {
            set { set(vector: newValue, for: "inputRedCoefficients") }
            get { return vector10(for: "inputRedCoefficients") }
        }

        var greenCoefficients: CIVector {
            set { set(vector: newValue, for: "inputGreenCoefficients") }
            get { return vector10(for: "inputGreenCoefficients") }
        }

        var blueCoefficients: CIVector {
            set { set(vector: newValue, for: "inputBlueCoefficients") }
            get { return vector10(for: "inputBlueCoefficients") }
        }

    }

}
