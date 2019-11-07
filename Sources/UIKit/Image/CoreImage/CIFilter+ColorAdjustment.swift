

import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
public extension CIFilter {

    convenience init(colorAdjustment type: ColorAdjustment) {
        self.init(name: type.rawValue)!
    }

    enum ColorAdjustment: String {
        case colorClamp            = "CIColorClamp"
        case colorControls         = "CIColorControls"
        case colorMatrix           = "CIColorMatrix"
        case colorPolynomial       = "CIColorPolynomial"
        case exposureAdjust        = "CIExposureAdjust"
        case gammaAdjust           = "CIGammaAdjust"
        case hueAdjust             = "CIHueAdjust"
        @available(OSX 10.10, *)
        case linearToSRGBToneCurve = "CILinearToSRGBToneCurve"
        @available(OSX 10.10, *)
        case sRGBToneCurveToLinear = "CISRGBToneCurveToLinear"
        case temperatureAndTint    = "CITemperatureAndTint"
        case toneCurve             = "CIToneCurve"
        case vibrance              = "CIVibrance"
        case whitePointAdjust      = "CIWhitePointAdjust"
    }

}

extension CIFilter.ColorAdjustment {

    public struct ColorClamp: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorClamp)

        @CIFilterValueBox var minComponents: CIVector
        @CIFilterValueBox var maxComponents: CIVector

        init() {
            _minComponents.cofig(filter: filter, name: "inputMinComponents", default: .init(string: "[0 0 0 0]"))
            _maxComponents.cofig(filter: filter, name: "inputMaxComponents", default: .init(string: "[1 1 1 1]"))
        }
    }

    public struct ColorControls: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorControls)

        @CIFilterValueBox var saturation: NSNumber
        @CIFilterValueBox var brightness: NSNumber?
        @CIFilterValueBox var contrast: NSNumber

        init() {
            _saturation.cofig(filter: filter, name: "inputSaturation", default: 1)
            _brightness.cofig(filter: filter, name: "inputBrightness", default: nil)
            _contrast.cofig(filter: filter, name: "inputContrast", default: 1)
        }
    }

    public struct ColorMatrix: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorMatrix)

        @CIFilterValueBox var rVector: CIVector
        @CIFilterValueBox var gVector: CIVector
        @CIFilterValueBox var bVector: CIVector
        @CIFilterValueBox var aVector: CIVector
        @CIFilterValueBox var biasVector: CIVector

        init() {
            _rVector.cofig(filter: filter, name: "inputRVector", default: .init(string: "[1 0 0 0]"))
            _gVector.cofig(filter: filter, name: "inputGVector", default: .init(string: "[0 1 0 0]"))
            _bVector.cofig(filter: filter, name: "inputBVector", default: .init(string: "[0 0 1 0]"))
            _aVector.cofig(filter: filter, name: "inputAVector", default: .init(string: "[0 0 0 1]"))
            _biasVector.cofig(filter: filter, name: "inputBiasVector", default: .init(string: "[0 0 0 0]"))
        }

    }

    public struct ColorPolynomial: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorPolynomial)

        @CIFilterValueBox var redCoefficients: CIVector
        @CIFilterValueBox var greenCoefficients: CIVector
        @CIFilterValueBox var blueCoefficients: CIVector
        @CIFilterValueBox var alphaCoefficients: CIVector

        init() {
            _redCoefficients.cofig(filter: filter, name: "inputRedCoefficients", default: .init(string: "[0 1 0 0]"))
            _greenCoefficients.cofig(filter: filter, name: "inputGreenCoefficients", default: .init(string: "[0 1 0 0]"))
            _blueCoefficients.cofig(filter: filter, name: "inputBlueCoefficients", default: .init(string: "[0 1 0 0]"))
            _alphaCoefficients.cofig(filter: filter, name: "inputAlphaCoefficients", default: .init(string: "[0 1 0 0]"))
        }

    }

    public struct ExposureAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .exposureAdjust)

        @CIFilterValueBox var ev: NSNumber

        init() {
            _ev.cofig(filter: filter, name: "inputEV", default: 0.50)
        }

    }

    public struct GammaAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .gammaAdjust)

        @CIFilterValueBox var power: NSNumber

        init() {
            _power.cofig(filter: filter, name: "inputPower", default: 0.75)
        }

    }

    public struct HueAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .hueAdjust)

        @CIFilterValueBox var angle: NSNumber

        init() {
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }

    }

    @available(OSX 10.10, *)
    public struct LinearToSRGBToneCurve: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .linearToSRGBToneCurve)

    }

    @available(OSX 10.10, *)
    public struct SRGBToneCurveToLinear: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .sRGBToneCurveToLinear)

    }

    public struct TemperatureAndTint: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .temperatureAndTint)

        @CIFilterValueBox var neutral: CIVector
        @CIFilterValueBox var targetNeutral: CIVector

        init() {
            _neutral.cofig(filter: filter, name: "inputNeutral", default: .init(string: " [6500, 0]"))
            _targetNeutral.cofig(filter: filter, name: "inputTargetNeutral", default: .init(string: "[6500, 0]"))
        }
    }

    public struct ToneCurve: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .toneCurve)

        @CIFilterValueBox var point0: CIVector
        @CIFilterValueBox var point1: CIVector
        @CIFilterValueBox var point2: CIVector
        @CIFilterValueBox var point3: CIVector
        @CIFilterValueBox var point4: CIVector

        init() {
            _point0.cofig(filter: filter, name: "inputPoint0", default: .init(string: "[0, 0]"))
            _point1.cofig(filter: filter, name: "inputPoint1", default: .init(string: "[0.25, 0.25]"))
            _point2.cofig(filter: filter, name: "inputPoint2", default: .init(string: "[0.5, 0.5]"))
            _point3.cofig(filter: filter, name: "inputPoint3", default: .init(string: "[0.75, 0.75]"))
            _point4.cofig(filter: filter, name: "inputPoint4", default: .init(string: "[1, 1]"))
        }

    }

    public struct Vibrance: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .vibrance)

        @CIFilterValueBox var amount: NSNumber?

        init() {
            _amount.cofig(filter: filter, name: "inputAmount", default: nil)
        }
    }

    public struct WhitePointAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .whitePointAdjust)

        @CIFilterValueBox var color: CIColor?

        init() {
            _color.cofig(filter: filter, name: "inputColor", default: nil)
        }
    }
}
