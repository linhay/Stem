
import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
public extension CIFilter {

    convenience init(colorAdjustment type: ColorEffect) {
        self.init(name: type.rawValue)!
    }

    enum ColorEffect: String {
        public typealias AllCases = String

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

    public struct ColorCrossPolynomial: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorCrossPolynomial)

        @CIFilterValueBox var redCoefficients: CIVector
        @CIFilterValueBox var greenCoefficients: CIVector
        @CIFilterValueBox var blueCoefficients: CIVector

        init() {
            self._redCoefficients.cofig(filter: filter, name: "inputRedCoefficients", default: .init(string: "[1 0 0 0 0 0 0 0 0 0]"))
            self._greenCoefficients.cofig(filter: filter, name: "inputGreenCoefficients", default: .init(string: "[0 1 0 0 0 0 0 0 0 0]"))
            self._blueCoefficients.cofig(filter: filter, name: "inputBlueCoefficients", default: .init(string: "[0 0 1 0 0 0 0 0 0 0]"))
        }
    }

    public struct ColorCube: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorCube)

        @CIFilterValueBox var cubeDimension: NSNumber
        @CIFilterValueBox var cubeData: Data?

        init() {
            self._cubeDimension.cofig(filter: filter, name: "inputRedCoefficients", default: 2)
            self._cubeData.cofig(filter: filter, name: "inputCubeData", default: nil)
        }

    }

    public struct ColorCubeWithColorSpace: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorCube)

        @CIFilterValueBox var cubeDimension: NSNumber
        @CIFilterValueBox var cubeData: Data?
        @CIFilterValueBox var colorSpace: CGColorSpace?

        init() {
            self._cubeDimension.cofig(filter: filter, name: "inputCubeDimension", default: 2)
            self._cubeData.cofig(filter: filter, name: "inputCubeData", default: nil)
            self._colorSpace.cofig(filter: filter, name: "inputColorSpace", default: nil)
        }

    }

    public struct ColorInvert: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorInvert)

    }

}
