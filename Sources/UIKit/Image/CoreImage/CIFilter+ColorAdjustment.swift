

import CoreImage

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
public extension CIFilter {

    convenience init(colorAdjustment type: ColorAdjustment) {
        self.init(name: type.rawValue)!
    }

    enum ColorAdjustment: String {
        @available(OSX 10.9, *) @available(iOS 7.0, *)
        case colorClamp            = "CIColorClamp"
        @available(OSX 10.4, *) @available(iOS 5.0, *)
        case colorControls         = "CIColorControls"
        @available(OSX 10.4, *) @available(iOS 5.0, *)
        case colorMatrix           = "CIColorMatrix"
        @available(OSX 10.9, *) @available(iOS 7.0, *)
        case colorPolynomial       = "CIColorPolynomial"
        @available(OSX 10.4, *) @available(iOS 5.0, *)
        case exposureAdjust        = "CIExposureAdjust"
        @available(OSX 10.4, *) @available(iOS 5.0, *)
        case gammaAdjust           = "CIGammaAdjust"
        @available(OSX 10.4, *) @available(iOS 5.0, *)
        case hueAdjust             = "CIHueAdjust"
        @available(OSX 10.10, *) @available(iOS 7.0, *)
        case linearToSRGBToneCurve = "CILinearToSRGBToneCurve"
        @available(OSX 10.10, *) @available(iOS 7.0, *)
        case sRGBToneCurveToLinear = "CISRGBToneCurveToLinear"
        @available(OSX 10.7, *) @available(iOS 5.0, *)
        case temperatureAndTint    = "CITemperatureAndTint"
        @available(OSX 10.7, *) @available(iOS 5.0, *)
        case toneCurve             = "CIToneCurve"
        @available(OSX 10.7, *) @available(iOS 5.0, *)
        case vibrance              = "CIVibrance"
        @available(OSX 10.7, *) @available(iOS 5.0, *)
        case whitePointAdjust      = "CIWhitePointAdjust"
    }

}

extension CIFilter.ColorAdjustment {

    @available(OSX 10.9, *) @available(iOS 7.0, *)
    public struct ColorClamp: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorClamp)

        var minComponents: CIVector {
            set { set(vector: newValue, for: "inputSaturation") }
            get { return vector4(for: "inputSaturation") }
        }

        var maxComponents: CIVector {
            set { set(vector: newValue, for: "inputSaturation") }
            get { return vector4(for: "inputSaturation") }
        }

    }

    @available(OSX 10.4, *) @available(iOS 5.0, *)
    public struct ColorControls: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorControls)

        var saturation: NSNumber {
            set { set(number: newValue, for: "inputSaturation") }
            get { return number(for: "inputSaturation") }
        }

        var brightness: NSNumber {
            set { set(number: newValue, for: "inputBrightness") }
            get { return number(for: "inputBrightness") }
        }

        var contrast: NSNumber {
            set { set(number: newValue, for: "inputContrast") }
            get { return number(for: "inputContrast") }
        }

    }

    @available(OSX 10.4, *) @available(iOS 5.0, *)
    public struct ColorMatrix: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorMatrix)

        var rVector: CIVector {
            set { set(vector: newValue, for: "inputRVector") }
            get { return vector4(for: "inputRVector") }
        }

        var gVector: CIVector {
            set { set(vector: newValue, for: "inputGVector") }
            get { return vector4(for: "inputGVector") }
        }

        var bVector: CIVector {
            set { set(vector: newValue, for: "inputBVector") }
            get { return vector4(for: "inputBVector") }
        }

        var aVector: CIVector {
            set { set(vector: newValue, for: "inputAVector") }
            get { return vector4(for: "inputAVector") }
        }

        var biasVector: CIVector {
            set { set(vector: newValue, for: "inputBiasVector") }
            get { return vector4(for: "inputBiasVector") }
        }

    }

    @available(OSX 10.9, *) @available(iOS 7.0, *)
    public struct ColorPolynomial: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .colorPolynomial)

        var redCoefficients: CIVector {
            set { set(vector: newValue, for: "inputRedCoefficients") }
            get { return vector4(for: "inputRedCoefficients") }
        }

        var greenCoefficients: CIVector {
            set { set(vector: newValue, for: "inputGreenCoefficients") }
            get { return vector4(for: "inputGreenCoefficients") }
        }

        var blueCoefficients: CIVector {
            set { set(vector: newValue, for: "inputBlueCoefficients") }
            get { return vector4(for: "inputBlueCoefficients") }
        }

        var alphaCoefficients: CIVector {
            set { set(vector: newValue, for: "inputAlphaCoefficients") }
            get { return vector4(for: "inputAlphaCoefficients") }
        }

    }

    @available(OSX 10.4, *) @available(iOS 5.0, *)
    public struct ExposureAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .exposureAdjust)

        var ev: NSNumber {
            set { set(number: newValue, for: "inputEV") }
            get { return number(for: "inputEV") }
        }

    }

    @available(OSX 10.4, *) @available(iOS 5.0, *)
    public struct GammaAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .gammaAdjust)

        var power: NSNumber {
            set { set(number: newValue, for: "inputPower") }
            get { return number(for: "inputPower") }
        }

    }

    @available(OSX 10.4, *) @available(iOS 5.0, *)
    public struct HueAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .hueAdjust)

        var angle: NSNumber {
            set { set(number: newValue, for: "inputAngle") }
            get { return number(for: "inputAngle") }
        }

    }

    @available(OSX 10.10, *) @available(iOS 7.0, *)
    public struct LinearToSRGBToneCurve: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .linearToSRGBToneCurve)

    }

    @available(OSX 10.10, *) @available(iOS 7.0, *)
    public struct SRGBToneCurveToLinear: CIFilterContainerProtocol, CIFilterInputImageProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .sRGBToneCurveToLinear)

    }

    @available(OSX 10.7, *) @available(iOS 5.0, *)
    public struct TemperatureAndTint: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .temperatureAndTint)

        var neutral: CIVector {
            set { set(vector: newValue, for: "inputNeutral") }
            get { return vector2(for: "inputNeutral") }
        }

        var targetNeutral: CIVector {
            set { set(vector: newValue, for: "inputTargetNeutral") }
            get { return vector2(for: "inputTargetNeutral") }
        }

    }

    @available(OSX 10.7, *) @available(iOS 5.0, *)
    public struct ToneCurve: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .toneCurve)

        var point0: CIVector {
            set { set(vector: newValue, for: "inputPoint0") }
            get { return vector2(for: "inputPoint0") }
        }

        var point1: CIVector {
            set { set(vector: newValue, for: "inputPoint1") }
            get { return vector2(for: "inputPoint1") }
        }

        var point2: CIVector {
            set { set(vector: newValue, for: "inputPoint2") }
            get { return vector2(for: "inputPoint2") }
        }

        var point3: CIVector {
            set { set(vector: newValue, for: "inputPoint3") }
            get { return vector2(for: "inputPoint3") }
        }

        var point4: CIVector {
            set { set(vector: newValue, for: "inputPoint4") }
            get { return vector2(for: "inputPoint4") }
        }

    }

    @available(OSX 10.7, *) @available(iOS 5.0, *)
    public struct Vibrance: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .vibrance)

        var amount: NSNumber {
            set { set(number: newValue, for: "inputAmount") }
            get { return number(for: "inputAmount") }
        }

    }


    @available(OSX 10.7, *) @available(iOS 5.0, *)
    public struct WhitePointAdjust: CIFilterContainerProtocol, CIFilterInputImageProtocol, CIFilterValueProtocol {

        public var filter: CIFilter = CIFilter(colorAdjustment: .whitePointAdjust)

        var color: NSNumber {
            set { set(number: newValue, for: "inputColor") }
            get { return number(for: "inputColor") }
        }

    }
}
