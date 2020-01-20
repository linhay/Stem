/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import UIKit

extension CIFilter {
    convenience init(blur type: Blur) {
        self.init(name: type.rawValue)!
    }
    public enum Blur: String {
        ///   and later and in iOS 9 and later.
        case boxBlur = "CIBoxBlur"
        ///   and later and in iOS 9 and later.
        case discBlur = "CIDiscBlur"
        case gaussianBlur = "CIGaussianBlur"
        ///  Available in OS X v10.10 and later.
        case maskedVariableBlur = "CIMaskedVariableBlur"
        ///   and later and in iOS 9 and later.
        case medianFilter = "CIMedianFilter"
        ///   and later and in iOS 9 and later.
        case motionBlur = "CIMotionBlur"
        ///   and later and in iOS 9 and later.
        case noiseReduction = "CINoiseReduction"
        ///   and later and in iOS 9 and later.
        case zoomBlur = "CIZoomBlur"
    }
}

extension CIFilter.Blur {
    
    ///   and later and in iOS 9 and later.
    public struct BoxBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .boxBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct DiscBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .discBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 8.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 8.00)
        }
    }

    public class GaussianBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .gaussianBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }
    /**
     Discussion
     Shades of gray in the mask image vary the blur radius from zero (where the mask image is black) to the radius specified in the inputRadius parameter (where the mask image is white).
     */
    ///  Available in OS X v10.10 and later.
    public struct MaskedVariableBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .maskedVariableBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Mask.
        @CIFilterValueBox var mask: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00 Minimum: 0.00 Maximum: 0.00 Slider minimum: 0.00 Slider maximum: 100.00 Identity: 0.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _mask.cofig(filter: filter, name: "inputMask", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }
    /**
     Discussion
     The effect is to reduce noise.
     */
    ///   and later and in iOS 9 and later.
    public struct MedianFilter: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .medianFilter)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct MotionBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .motionBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 20.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 20.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }
    }
    /**
     Discussion
     Small changes in luminance below that value are considered noise and get a noise reduction treatment, which is a local blur. Changes above the threshold value are considered edges, so they are sharpened.
     */
    ///   and later and in iOS 9 and later.
    public struct NoiseReduction: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .noiseReduction)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Noise Level.
        ///  Default value: 0.02
        @CIFilterValueBox var noiseLevel: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.40
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _noiseLevel.cofig(filter: filter, name: "inputNoiseLevel", default: 0.02)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.40)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct ZoomBlur: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(blur: .zoomBlur)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Amount.
        ///  Default value: 20.00
        @CIFilterValueBox var amount: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _amount.cofig(filter: filter, name: "inputAmount", default: 20.00)
        }
    }
}
extension CIFilter {
    convenience init(colorAdjustment type: ColorAdjustment) {
        self.init(name: type.rawValue)!
    }
    public enum ColorAdjustment: String {
        case colorClamp = "CIColorClamp"
        case colorControls = "CIColorControls"
        case colorMatrix = "CIColorMatrix"
        case colorPolynomial = "CIColorPolynomial"
        case exposureAdjust = "CIExposureAdjust"
        case gammaAdjust = "CIGammaAdjust"
        case hueAdjust = "CIHueAdjust"
        ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
        case linearToSRGBToneCurve = "CILinearToSRGBToneCurve"
        ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
        case sRGBToneCurveToLinear = "CISRGBToneCurveToLinear"
        case temperatureAndTint = "CITemperatureAndTint"
        case toneCurve = "CIToneCurve"
        case vibrance = "CIVibrance"
        case whitePointAdjust = "CIWhitePointAdjust"
    }
}
extension CIFilter.ColorAdjustment {
    /**
     Discussion
     At each pixel, color component values less than those in inputMinComponents will be increased to match those in inputMinComponents, and color component values greater than those in inputMaxComponents will be decreased to match those in inputMaxComponents.
     */
    public struct ColorClamp: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .colorClamp)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  RGBA values for the lower end of the range. A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is MinComponents.
        ///  Default value: [0 0 0 0] Identity: [0 0 0 0]
        @CIFilterValueBox var minComponents: CIVector
        
        ///  RGBA values for the upper end of the range. A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is MaxComponents.
        ///  Default value: [1 1 1 1] Identity: [1 1 1 1]
        @CIFilterValueBox var maxComponents: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _minComponents.cofig(filter: filter, name: "inputMinComponents", default: .init(string: "[0 0 0 0]"))
            _maxComponents.cofig(filter: filter, name: "inputMaxComponents", default: .init(string: "[1 1 1 1]"))
        }
    }
    /**
     Discussion
     To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation.
     To calculate contrast, this filter uses the following formula:
     (color.rgb - vec3(0.5)) * contrast  +  vec3(0.5)
     This filter calculates brightness by adding a bias value:
     color.rgb + vec3(brightness)
     */
    public struct ColorControls: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .colorControls)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Saturation.
        ///  Default value: 1.00
        @CIFilterValueBox var saturation: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Brightness.
        @CIFilterValueBox var brightness: NSNumber?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast.
        ///  Default value: 1.00
        @CIFilterValueBox var contrast: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _saturation.cofig(filter: filter, name: "inputSaturation", default: 1.00)
            _brightness.cofig(filter: filter, name: "inputBrightness", default: nil)
            _contrast.cofig(filter: filter, name: "inputContrast", default: 1.00)
        }
    }
    /**
     Discussion
     This filter performs a matrix multiplication, as follows, to transform the color vector:
     
     
     s.r = dot(s, redVector)
     s.g = dot(s, greenVector)
     s.b = dot(s, blueVector)
     s.a = dot(s, alphaVector)
     s = s + bias
     
     
     Note
     
     As with all color filters, this operation is performed in the working color space of the Core Image context (CIContext) executing the filter, using unpremultiplied pixel color values. If you see unexpected results, verify that your output and working color spaces are set up as intended.
     
     
     */
    public struct ColorMatrix: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .colorMatrix)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Red Vector.
        ///  Default value: [1 0 0 0]
        @CIFilterValueBox var rVector: CIVector
        
        ///  A CIVector object whose display name is Green Vector.
        ///  Default value: [0 1 0 0]
        @CIFilterValueBox var gVector: CIVector
        
        ///  A CIVector object whose display name is Blue Vector.
        ///  Default value: [0 0 1 0]
        @CIFilterValueBox var bVector: CIVector
        
        ///  A CIVector object whose display name is Alpha Vector.
        ///  Default value: [0 0 0 1]
        @CIFilterValueBox var aVector: CIVector
        
        ///  A CIVector object whose display name is Bias Vector.
        ///  Default value: [0 0 0 0]
        @CIFilterValueBox var biasVector: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _rVector.cofig(filter: filter, name: "inputRVector", default: .init(string: "[1 0 0 0] "))
            _gVector.cofig(filter: filter, name: "inputGVector", default: .init(string: "[0 1 0 0]"))
            _bVector.cofig(filter: filter, name: "inputBVector", default: .init(string: "[0 0 1 0] "))
            _aVector.cofig(filter: filter, name: "inputAVector", default: .init(string: "[0 0 0 1] "))
            _biasVector.cofig(filter: filter, name: "inputBiasVector", default: .init(string: "[0 0 0 0]"))
        }
    }
    /**
     Discussion
     For each pixel, the value of each color component is treated as the input to a cubic polynomial, whose coefficients are taken from the corresponding input coefficients parameter in ascending order. Equivalent to the following formula:
     
     
     r = rCoeff[0] + rCoeff[1] * r + rCoeff[2] * r*r + rCoeff[3] * r*r*r
     g = gCoeff[0] + gCoeff[1] * g + gCoeff[2] * g*g + gCoeff[3] * g*g*g
     b = bCoeff[0] + bCoeff[1] * b + bCoeff[2] * b*b + bCoeff[3] * b*b*b
     a = aCoeff[0] + aCoeff[1] * a + aCoeff[2] * a*a + aCoeff[3] * a*a*a
     
     
     Note
     
     As with all color filters, this operation is performed in the working color space of the Core Image context (CIContext) executing the filter, using unpremultiplied pixel color values. If you see unexpected results, verify that your output and working color spaces are set up as intended.
     
     
     */
    public struct ColorPolynomial: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .colorPolynomial)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is RedCoefficients.
        ///  Default value: [0 1 0 0] Identity: [0 1 0 0]
        @CIFilterValueBox var redCoefficients: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is GreenCoefficients.
        ///  Default value: [0 1 0 0] Identity: [0 1 0 0]
        @CIFilterValueBox var greenCoefficients: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is BlueCoefficients.
        ///  Default value: [0 1 0 0] Identity: [0 1 0 0]
        @CIFilterValueBox var blueCoefficients: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is AlphaCoefficients.
        ///  Default value: [0 1 0 0] Identity: [0 1 0 0]
        @CIFilterValueBox var alphaCoefficients: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _redCoefficients.cofig(filter: filter, name: "inputRedCoefficients", default: .init(string: "[0 1 0 0]"))
            _greenCoefficients.cofig(filter: filter, name: "inputGreenCoefficients", default: .init(string: "[0 1 0 0]"))
            _blueCoefficients.cofig(filter: filter, name: "inputBlueCoefficients", default: .init(string: "[0 1 0 0]"))
            _alphaCoefficients.cofig(filter: filter, name: "inputAlphaCoefficients", default: .init(string: "[0 1 0 0]"))
        }
    }
    /**
     Discussion
     This filter multiplies the color values, as follows, to simulate exposure change by the specified F-stops:
     s.rgb * pow(2.0, ev)
     */
    public struct ExposureAdjust: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .exposureAdjust)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is EV.
        ///  Default value: 0.50
        @CIFilterValueBox var eV: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _eV.cofig(filter: filter, name: "inputEV", default: 0.50)
        }
    }
    /**
     Discussion
     This filter is typically used to compensate for nonlinear effects of displays. Adjusting the gamma effectively changes the slope of the transition between black and white. It uses the following formula:
     pow(s.rgb, vec3(power))
     Note
     
     As with all color filters, this operation is performed in the working color space of the Core Image context (CIContext) executing the filter, using unpremultiplied pixel color values. If you see unexpected results, verify that your output and working color spaces are set up as intended.
     
     
     */
    public struct GammaAdjust: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .gammaAdjust)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Power.
        ///  Default value: 0.75
        @CIFilterValueBox var power: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _power.cofig(filter: filter, name: "inputPower", default: 0.75)
        }
    }
    /**
     Discussion
     This filter essentially rotates the color cube around the neutral axis.
     */
    public struct HueAdjust: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .hueAdjust)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }
    }
    
    ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
    public struct LinearToSRGBToneCurve: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .linearToSRGBToneCurve)
        
        ///  A CIImage object whose attribute type is CIAttributeTypeImage and whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }
    
    ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
    public struct SRGBToneCurveToLinear: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .sRGBToneCurveToLinear)
        
        ///  A CIImage object whose attribute type is CIAttributeTypeImage and whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct TemperatureAndTint: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .temperatureAndTint)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset and whose display name is Neutral.
        ///  Default value: [6500, 0]
        @CIFilterValueBox var neutral: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset and whose display name is TargetNeutral
        ///  Default value: [6500, 0]
        @CIFilterValueBox var targetNeutral: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _neutral.cofig(filter: filter, name: "inputNeutral", default: .init(string: "[6500, 0]"))
            _targetNeutral.cofig(filter: filter, name: "inputTargetNeutral", default: .init(string: "[6500, 0]"))
        }
    }
    /**
     Discussion
     The input points are five x,y values that are interpolated using a spline curve. The curve is applied in a perceptual (gamma 2) version of the working space.
     */
    public struct ToneCurve: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .toneCurve)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset.
        ///  Default value: [0, 0]
        @CIFilterValueBox var point0: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset.
        ///  Default value: [0.25, 0.25]
        @CIFilterValueBox var point1: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset.
        ///  Default value: [0.5, 0.5]
        @CIFilterValueBox var point2: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset.
        ///  Default value: [0.75, 0.75]
        @CIFilterValueBox var point3: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset.
        ///  Default value: [1, 1]
        @CIFilterValueBox var point4: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _point0.cofig(filter: filter, name: "inputPoint0", default: .init(string: "[0, 0]"))
            _point1.cofig(filter: filter, name: "inputPoint1", default: .init(string: "[0.25, 0.25]"))
            _point2.cofig(filter: filter, name: "inputPoint2", default: .init(string: "[0.5, 0.5]"))
            _point3.cofig(filter: filter, name: "inputPoint3", default: .init(string: "[0.75, 0.75]"))
            _point4.cofig(filter: filter, name: "inputPoint4", default: .init(string: "[1, 1]"))
        }
    }

    public struct Vibrance: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .vibrance)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Amount.
        @CIFilterValueBox var amount: NSNumber?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _amount.cofig(filter: filter, name: "inputAmount", default: nil)
        }
    }

    public struct WhitePointAdjust: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorAdjustment: .whitePointAdjust)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIColor object whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _color.cofig(filter: filter, name: "inputColor", default: nil)
        }
    }
}
extension CIFilter {
    convenience init(colorEffect type: ColorEffect) {
        self.init(name: type.rawValue)!
    }
    public enum ColorEffect: String {
        case colorCrossPolynomial = "CIColorCrossPolynomial"
        case colorCube = "CIColorCube"
        case colorCubeWithColorSpace = "CIColorCubeWithColorSpace"
        case colorInvert = "CIColorInvert"
        case colorMap = "CIColorMap"
        case colorMonochrome = "CIColorMonochrome"
        case colorPosterize = "CIColorPosterize"
        case falseColor = "CIFalseColor"
        case maskToAlpha = "CIMaskToAlpha"
        case maximumComponent = "CIMaximumComponent"
        case minimumComponent = "CIMinimumComponent"
        case photoEffectChrome = "CIPhotoEffectChrome"
        case photoEffectFade = "CIPhotoEffectFade"
        case photoEffectInstant = "CIPhotoEffectInstant"
        case photoEffectMono = "CIPhotoEffectMono"
        case photoEffectNoir = "CIPhotoEffectNoir"
        case photoEffectProcess = "CIPhotoEffectProcess"
        case photoEffectTonal = "CIPhotoEffectTonal"
        case photoEffectTransfer = "CIPhotoEffectTransfer"
        case sepiaTone = "CISepiaTone"
        case vignette = "CIVignette"
        case vignetteEffect = "CIVignetteEffect"
    }
}
extension CIFilter.ColorEffect {
    /**
     Discussion
     Each component in an output pixel out is determined using the component values in the input pixel in according to a polynomial cross product with the input coefficients. That is, the red component of the output pixel is calculated using the inputRedCoefficients parameter (abbreviated rC below) using the following formula:
     
     
     out.r =        in.r * rC[0] +        in.g * rC[1] +        in.b * rC[2]
     + in.r * in.r * rC[3] + in.g * in.g * rC[4] + in.b * in.b * rC[5]
     + in.r * in.g * rC[6] + in.g * in.b * rC[7] + in.b * in.r * rC[8]
     + rC[9]
     
     
     Then, the formula is repeated to calculate the blue and green components of the output pixel using the blue and green coefficients, respectively.
     This filter can be used for advanced color space and tone mapping conversions, such as imitating the color reproduction of vintage photography film.
     Note
     
     As with all color filters, this operation is performed in the working color space of the Core Image context (CIContext) executing the filter, using unpremultiplied pixel color values. If you see unexpected results, verify that your output and working color spaces are set up as intended.
     
     
     */
    public struct ColorCrossPolynomial: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorCrossPolynomial)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is RedCoefficients.
        ///  Default value: [1 0 0 0 0 0 0 0 0 0] Identity: [1 0 0 0 0 0 0 0 0 0]
        @CIFilterValueBox var redCoefficients: CIVector
        
        ///  A CIVector object whose display name is GreenCoefficients.
        ///  Default value: [0 1 0 0 0 0 0 0 0 0] Identity: [0 1 0 0 0 0 0 0 0 0]
        @CIFilterValueBox var greenCoefficients: CIVector
        
        ///  A CIVector object whose display name is BlueCoefficients.
        ///  Default value: [0 0 1 0 0 0 0 0 0 0] Identity: [0 0 1 0 0 0 0 0 0 0]
        @CIFilterValueBox var blueCoefficients: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _redCoefficients.cofig(filter: filter, name: "inputRedCoefficients", default: .init(string: "[1 0 0 0 0 0 0 0 0 0]"))
            _greenCoefficients.cofig(filter: filter, name: "inputGreenCoefficients", default: .init(string: "[0 1 0 0 0 0 0 0 0 0]"))
            _blueCoefficients.cofig(filter: filter, name: "inputBlueCoefficients", default: .init(string: "[0 0 1 0 0 0 0 0 0 0]"))
        }
    }
    /**
     Discussion
     This filter maps color values in the input image to new color values using a three-dimensional color lookup table (also called a CLUT or color cube). For each RGBA pixel in the input image, the filter uses the R, G, and B component values as indices to identify a location in the table; the RGBA value at that location becomes the RGBA value of the output pixel.
     Use the inputCubeData parameter to provide data formatted for use as a color lookup table, and the inputCubeDimension parameter to specify the size of the table. This data should be an array of texel values in 32-bit floating-point RGBA linear premultiplied format. The inputCubeDimension parameter identifies the size of the cube by specifying the length of one side, so the size of the array should be inputCubeDimension cubed times the size of a single texel value. In the color table, the R component varies fastest, followed by G, then B. Listing 1 shows a basic pattern for creating color cube data.
     Listing 1Creating a Color Table for the CIColorCube Filter
     
     
     // Allocate and opulate color cube table
     const unsigned int size = 64;
     float *cubeData = (float *)malloc(size * size * size * sizeof(float) * 4);
     for (int b = 0; b < size; b++) {
     for (int g = 0; g < size; r++) {
     for (int r = 0; r < size; r ++) {
     cubeData[b][g][r][0] = <# output R value #>;
     cubeData[b][g][r][1] = <# output G value #>;
     cubeData[b][g][r][2] = <# output B value #>;
     cubeData[b][g][r][3] = <# output A value #>;
     }
     }
     }
     // Put the table in a data object and create the filter
     NSData *data = [NSData dataWithBytesNoCopy:cubeData
     length:cubeDataSize
     freeWhenDone:YES];
     CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"
     withInputParameters:@{
     @"inputCubeDimension": @(size),
     @"inputCubeData": data,
     }];
     
     
     For another example of this filter in action, see Chroma Key Filter Recipe in Core Image Programming Guide.
     Note
     
     As with all color filters, this operation is performed in the working color space of the Core Image context (CIContext) executing the filter, using unpremultiplied pixel color values. If you see unexpected results, verify that your output and working color spaces are set up as intended.
     
     
     */
    public struct ColorCube: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorCube)
        
        ///  The image to be transformed. (A CIImage object whose display name is Image.)
        @CIFilterValueBox var image: CIImage?
        
        ///  The length, in texels, of each side of the cube texture. (An NSNumber object whose attribute type is CIAttributeTypeCount and whose display name is Cube Dimension.)
        ///  Default value: 2.00
        @CIFilterValueBox var cubeDimension: NSNumber
        
        ///  The cube texture data to use as a color lookup table. (An NSData object whose display name is Cube Data.)
        @CIFilterValueBox var cubeData: Data?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _cubeDimension.cofig(filter: filter, name: "inputCubeDimension", default: 2.00)
            _cubeData.cofig(filter: filter, name: "inputCubeData", default: nil)
        }
    }
    /**
     Discussion
     See CIColorCube for more details on the color cube operation. To provide a CGColorSpaceRef object as the input parameter, cast it to type id. With the default color space (null), which is equivalent to kCGColorSpaceGenericRGBLinear, this filter’s effect is identical to that of CIColorCube.
     Figure 24 uses the same color cube as Figure 23, but with the sRGB color space.
     */
    public struct ColorCubeWithColorSpace: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorCubeWithColorSpace)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeCount and whose display name is Cube Dimension.
        ///  Default value: 2.00 Minimum: 2.00 Maximum: 128.00 Identity: 2.00
        @CIFilterValueBox var cubeDimension: NSNumber
        
        ///  An NSData object whose display name is Cube Data.
        @CIFilterValueBox var cubeData: Data?
        
        ///  An CGColorSpaceRef object whose display name is ColorSpace.
        @CIFilterValueBox var colorSpace: CGColorSpace?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _cubeDimension.cofig(filter: filter, name: "inputCubeDimension", default: 2.00)
            _cubeData.cofig(filter: filter, name: "inputCubeData", default: nil)
            _colorSpace.cofig(filter: filter, name: "inputColorSpace", default: nil)
        }
    }

    public struct ColorInvert: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorInvert)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct ColorMap: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorMap)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose attribute type is CIAttributeTypeGradient and whose display name is Gradient Image.
        @CIFilterValueBox var gradientImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _gradientImage.cofig(filter: filter, name: "inputGradientImage", default: nil)
        }
    }

    public struct ColorMonochrome: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorMonochrome)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 1.00
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 1.00)
        }
    }
    /**
     Discussion
     This filter flattens colors to achieve a look similar to that of a silk-screened poster.
     */
    public struct ColorPosterize: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .colorPosterize)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Levels.
        ///  Default value: 6.00
        @CIFilterValueBox var levels: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _levels.cofig(filter: filter, name: "inputLevels", default: 6.00)
        }
    }
    /**
     Discussion
     False color is often used to process astronomical and other scientific data, such as ultraviolet and x-ray images.
     */
    public struct FalseColor: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .falseColor)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox var color1: CIColor?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
        }
    }
    /**
     Discussion
     The white values from the source image produce the inside of the mask; the black values become completely transparent.
     */
    public struct MaskToAlpha: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .maskToAlpha)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }
    
    public struct MaximumComponent: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .maximumComponent)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct MinimumComponent: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .minimumComponent)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectChrome: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectChrome)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectFade: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectFade)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectInstant: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectInstant)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectMono: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectMono)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectNoir: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectNoir)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectProcess: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectProcess)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectTonal: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectTonal)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct PhotoEffectTransfer: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .photoEffectTransfer)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }

    public struct SepiaTone: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .sepiaTone)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 1.00
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 1.00)
        }
    }

    public struct Vignette: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .vignette)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 1.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 0.0
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 1.00)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 0.0)
        }
    }

    public struct VignetteEffect: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(colorEffect: .vignetteEffect)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150] Identity: (null)
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 1.00 Minimum: 0.00 Maximum: 0.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var intensity: NSNumber
        
        ///  An NSNumber object whose display name is Radius.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 0.00 Slider minimum: 0.00 Slider maximum: 0.00 Identity: 0.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 1.00)
            _radius.cofig(filter: filter, name: "inputRadius", default: 0.00)
        }
    }
}
extension CIFilter {
    convenience init(compositeOperation type: CompositeOperation) {
        self.init(name: type.rawValue)!
    }
    public enum CompositeOperation: String {
        case additionCompositing = "CIAdditionCompositing"
        case colorBlendMode = "CIColorBlendMode"
        case colorBurnBlendMode = "CIColorBurnBlendMode"
        case colorDodgeBlendMode = "CIColorDodgeBlendMode"
        case darkenBlendMode = "CIDarkenBlendMode"
        case differenceBlendMode = "CIDifferenceBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case divideBlendMode = "CIDivideBlendMode"
        case exclusionBlendMode = "CIExclusionBlendMode"
        case hardLightBlendMode = "CIHardLightBlendMode"
        case hueBlendMode = "CIHueBlendMode"
        case lightenBlendMode = "CILightenBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case linearBurnBlendMode = "CILinearBurnBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case linearDodgeBlendMode = "CILinearDodgeBlendMode"
        case luminosityBlendMode = "CILuminosityBlendMode"
        case maximumCompositing = "CIMaximumCompositing"
        case minimumCompositing = "CIMinimumCompositing"
        case multiplyBlendMode = "CIMultiplyBlendMode"
        case multiplyCompositing = "CIMultiplyCompositing"
        case overlayBlendMode = "CIOverlayBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case pinLightBlendMode = "CIPinLightBlendMode"
        case saturationBlendMode = "CISaturationBlendMode"
        case screenBlendMode = "CIScreenBlendMode"
        case softLightBlendMode = "CISoftLightBlendMode"
        case sourceAtopCompositing = "CISourceAtopCompositing"
        case sourceInCompositing = "CISourceInCompositing"
        case sourceOutCompositing = "CISourceOutCompositing"
        case sourceOverCompositing = "CISourceOverCompositing"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case subtractBlendMode = "CISubtractBlendMode"
    }
}
extension CIFilter.CompositeOperation {
    /**
     Discussion
     This filter is typically used to add highlights and lens flare effects. The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct AdditionCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .additionCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This mode preserves the gray levels in the image. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct ColorBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .colorBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     Source image sample values that specify white do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct ColorBurnBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .colorBurnBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     Source image sample values that specify black do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct ColorDodgeBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .colorDodgeBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The result is that the background image samples are replaced by any source image samples that are darker. Otherwise, the background image samples are left unchanged. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct DarkenBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .darkenBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     Source image sample values that are black produce no change; white inverts the background color values. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct DifferenceBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .differenceBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct DivideBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .divideBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     Source image sample values that are black do not produce a change; white inverts the background color values. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct ExclusionBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .exclusionBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     If the source image sample color is lighter than 50% gray, the background is lightened, similar to screening. If the source image sample color is darker than 50% gray, the background is darkened, similar to multiplying. If the source image sample color is equal to 50% gray, the source image is not changed. Image samples that are equal to pure black or pure white result in pure black or white. The overall effect is similar to what you would achieve by shining a harsh spotlight on the source image. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct HardLightBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .hardLightBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct HueBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .hueBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The result is that the background image samples are replaced by any source image samples that are lighter. Otherwise, the background image samples are left unchanged. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct LightenBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .lightenBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The effect of this filter is similar to that of the CIColorBurnBlendMode filter, but more pronounced.
     */
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct LinearBurnBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .linearBurnBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The effect of this filter is similar to that of the CIColorDodgeBlendMode filter, but more pronounced.
     */
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct LinearDodgeBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .linearDodgeBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This mode creates an effect that is inverse to the effect created by the CIColorBlendMode filter. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct LuminosityBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .luminosityBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This is similar to dodging.  The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct MaximumCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .maximumCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This is similar to burning.  The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct MinimumCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .minimumCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This results in colors that are at least as dark as either of the two contributing sample colors. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct MultiplyBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .multiplyBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This filter is typically used to add a spotlight or similar lighting effect to an image.  The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct MultiplyCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .multiplyCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The result is to overlay the existing image samples while preserving the highlights and shadows of the background. The background color mixes with the source image to reflect the lightness or darkness of the background. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct OverlayBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .overlayBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct PinLightBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .pinLightBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     Areas of the background that have no saturation (that is, pure gray areas) do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct SaturationBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .saturationBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     This results in colors that are at least as light as either of the two contributing sample colors. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct ScreenBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .screenBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     If the source image sample color is lighter than 50% gray, the background is lightened, similar to dodging. If the source image sample color is darker than 50% gray, the background is darkened, similar to burning. If the source image sample color is equal to 50% gray, the background is not changed. Image samples that are equal to pure black or pure white produce darker or lighter areas, but do not result in pure black or white. The overall effect is similar to what you would achieve by shining a diffuse spotlight on the source image. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
     */
    public struct SoftLightBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .softLightBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The composite shows the background image and only those portions of the source image that are over visible parts of the background.  The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct SourceAtopCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .sourceAtopCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct SourceInCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .sourceInCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct SourceOutCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .sourceOutCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    /**
     Discussion
     The formula used to create this filter is described in  Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
     */
    public struct SourceOverCompositing: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .sourceOverCompositing)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
    
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct SubtractBlendMode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(compositeOperation: .subtractBlendMode)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
        }
    }
}
extension CIFilter {
    convenience init(distortionEffect type: DistortionEffect) {
        self.init(name: type.rawValue)!
    }
    public enum DistortionEffect: String {
        case bumpDistortion = "CIBumpDistortion"
        ///   and later.
        case bumpDistortionLinear = "CIBumpDistortionLinear"
        case circleSplashDistortion = "CICircleSplashDistortion"
        ///   and later and in iOS 9 and later.
        case circularWrap = "CICircularWrap"
        ///   and later and in iOS 9 and later.
        case droste = "CIDroste"
        ///   and later and in iOS 9 and later.
        case displacementDistortion = "CIDisplacementDistortion"
        case glassDistortion = "CIGlassDistortion"
        ///   and later and in iOS 9 and later.
        case glassLozenge = "CIGlassLozenge"
        case holeDistortion = "CIHoleDistortion"
        ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
        case lightTunnel = "CILightTunnel"
        case pinchDistortion = "CIPinchDistortion"
        ///   and later and in iOS 9 and later.
        case stretchCrop = "CIStretchCrop"
        ///   and later and in iOS 9 and later.
        case torusLensDistortion = "CITorusLensDistortion"
        case twirlDistortion = "CITwirlDistortion"
        case vortexDistortion = "CIVortexDistortion"
    }
}
extension CIFilter.DistortionEffect {
    /**
     Discussion
     The bump can be concave or convex.
     */
    public struct BumpDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .bumpDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 0.50
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150] "))
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
            _scale.cofig(filter: filter, name: "inputScale", default: 0.50)
        }
    }
    
    ///   and later.
    public struct BumpDistortionLinear: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .bumpDistortionLinear)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [300 300]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 0.50
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[300 300]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _scale.cofig(filter: filter, name: "inputScale", default: 0.50)
        }
    }

    public struct CircleSplashDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .circleSplashDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 150.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 150.00)
        }
    }
    /**
     Discussion
     The distortion of the image increases with the distance from the center of the circle.
     */
    ///   and later and in iOS 9 and later.
    public struct CircularWrap: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .circularWrap)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 150.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 150.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct Droste: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .droste)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition.
        ///  Default value: [200 200]
        @CIFilterValueBox var insetPoint0: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition.
        ///  Default value: [400 400]
        @CIFilterValueBox var insetPoint1: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 1
        @CIFilterValueBox var strands: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance.
        ///  Default value: 1
        @CIFilterValueBox var periodicity: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance.
        ///  Default value: 0.00
        @CIFilterValueBox var rotation: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar.
        ///  Default value: 1
        @CIFilterValueBox var zoom: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _insetPoint0.cofig(filter: filter, name: "inputInsetPoint0", default: .init(string: "[200 200]"))
            _insetPoint1.cofig(filter: filter, name: "inputInsetPoint1", default: .init(string: "[400 400]"))
            _strands.cofig(filter: filter, name: "inputStrands", default: 1)
            _periodicity.cofig(filter: filter, name: "inputPeriodicity", default: 1)
            _rotation.cofig(filter: filter, name: "inputRotation", default: 0.00)
            _zoom.cofig(filter: filter, name: "inputZoom", default: 1)
        }
    }
    /**
     Discussion
     The output image has a texture defined by the grayscale values.
     */
    ///   and later and in iOS 9 and later.
    public struct DisplacementDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .displacementDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Displacement Image.
        @CIFilterValueBox var displacementImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Scale.
        ///  Default value: 50.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _displacementImage.cofig(filter: filter, name: "inputDisplacementImage", default: nil)
            _scale.cofig(filter: filter, name: "inputScale", default: 50.00)
        }
    }
    /**
     Discussion
     The raised portions of the output image are the result of applying a texture map.
     */
    public struct GlassDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .glassDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Texture.
        @CIFilterValueBox var texture: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150] Identity: (null)
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Scale.
        ///  Default value: 200.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _texture.cofig(filter: filter, name: "inputTexture", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _scale.cofig(filter: filter, name: "inputScale", default: 200.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct GlassLozenge: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .glassLozenge)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 1.
        ///  Default value: [150 150]
        @CIFilterValueBox var point0: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 2.
        ///  Default value: [350 150]
        @CIFilterValueBox var point1: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 100.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Refraction.
        ///  Default value: 1.70
        @CIFilterValueBox var refraction: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _point0.cofig(filter: filter, name: "inputPoint0", default: .init(string: "[150 150]"))
            _point1.cofig(filter: filter, name: "inputPoint1", default: .init(string: "[350 150] "))
            _radius.cofig(filter: filter, name: "inputRadius", default: 100.00)
            _refraction.cofig(filter: filter, name: "inputRefraction", default: 1.70)
        }
    }

    public struct HoleDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .holeDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 150.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 150.00)
        }
    }
    
    ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
    public struct LightTunnel: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .lightTunnel)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle.
        ///  Default value: 0.00
        @CIFilterValueBox var rotation: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle.
        ///  Default value: 0.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _rotation.cofig(filter: filter, name: "inputRotation", default: 0.00)
            _radius.cofig(filter: filter, name: "inputRadius", default: 0.00)
        }
    }

    public struct PinchDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .pinchDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 0.50
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
            _scale.cofig(filter: filter, name: "inputScale", default: 0.50)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct StretchCrop: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .stretchCrop)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Size. This value specifies the size of the output image in pixels.
        @CIFilterValueBox var size: CIVector?
        
        ///  An NSNumber object whose display name is CropAmount. This value determines if, and how much, cropping should be used to achieve the target size. If the value is 0, the image is stretched but not cropped. If the value is 1, the image is cropped but not stretched. Values in-between use stretching and cropping proportionally.
        @CIFilterValueBox var cropAmount: NSNumber?
        
        ///  An NSNumber object whose display name is CenterStretchAmount. This value determines how much stretching to apply to the center of the image, if stretching is indicated by the inputCropAmount value. A value of 0 causes the center of the image to maintain its original aspect ratio. A value of 1 causes the image to be stretched uniformly.
        @CIFilterValueBox var centerStretchAmount: NSNumber?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _size.cofig(filter: filter, name: "inputSize", default: nil)
            _cropAmount.cofig(filter: filter, name: "inputCropAmount", default: nil)
            _centerStretchAmount.cofig(filter: filter, name: "inputCenterStretchAmount", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct TorusLensDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .torusLensDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 160.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 80.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Refraction.
        ///  Default value: 1.70
        @CIFilterValueBox var refraction: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 160.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 80.00)
            _refraction.cofig(filter: filter, name: "inputRefraction", default: 1.70)
        }
    }
    /**
     Discussion
     You can specify the number of rotations as well as the center and radius of the effect.
     */
    public struct TwirlDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .twirlDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 3.14
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 3.14)
        }
    }
    /**
     Discussion
     You can specify the number of rotations as well the center and radius of the effect.
     */
    public struct VortexDistortion: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(distortionEffect: .vortexDistortion)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 56.55
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 56.55)
        }
    }
}

extension CIFilter {
    convenience init(geometryAdjustment type: GeometryAdjustment) {
        self.init(name: type.rawValue)!
    }
    public enum GeometryAdjustment: String {
        case affineTransform = "CIAffineTransform"
        case crop = "CICrop"
        case lanczosScaleTransform = "CILanczosScaleTransform"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case perspectiveCorrection = "CIPerspectiveCorrection"
        case perspectiveTransform = "CIPerspectiveTransform"
        ///  Available in iOS 6.0 and later.
        case perspectiveTransformWithExtent = "CIPerspectiveTransformWithExtent"
        case straightenFilter = "CIStraightenFilter"
    }
}
extension CIFilter.GeometryAdjustment {
    /**
     Discussion
     You can scale, translate, or rotate the input image. You can also apply a combination of these operations.
     */
    public struct AffineTransform: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .affineTransform)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  On iOS, an NSValue object whose attribute type is CIAttributeTypeTransform. You must pass the transform as NSData using a statement similar to the following, where xform is an affine transform:
        ///
        ///
        ///            [myFilter setValue:[NSValue valueWithBytes:&xform
        ///                                              objCType:@encode(CGAffineTransform)]
        ///                        forKey:@"inputTransform"];
        ///
        ///
        ///  On OS X, an NSAffineTransform object whose attribute type is CIAttributeTypeTransform.
        @CIFilterValueBox var transform: NSValue?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _transform.cofig(filter: filter, name: "inputTransform", default: nil)
        }
    }
    /**
     Discussion
     The size and shape of the cropped image depend on the rectangle you specify.
     */
    public struct Crop: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .crop)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Rectangle.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var rectangle: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _rectangle.cofig(filter: filter, name: "inputRectangle", default: .init(string: "[0 0 300 300]"))
        }
    }
    /**
     Discussion
     You typically use this filter to scale down an image.
     */
    public struct LanczosScaleTransform: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .lanczosScaleTransform)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 1.00
        @CIFilterValueBox var scale: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Aspect Ratio.
        ///  Default value: 1.00
        @CIFilterValueBox var aspectRatio: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _scale.cofig(filter: filter, name: "inputScale", default: 1.00)
            _aspectRatio.cofig(filter: filter, name: "inputAspectRatio", default: 1.00)
        }
    }
    /**
     Discussion
     The extent of the rectangular output image varies based on the size and placement of the specified quadrilateral region in the input image.
     */
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct PerspectiveCorrection: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .perspectiveCorrection)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  The point in the input image to be mapped to the top left corner of the output image.
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Left.
        ///  Default value: [118 484] Identity: (null)
        @CIFilterValueBox var topLeft: CIVector
        
        ///  The point in the input image to be mapped to the top right corner of the output image.
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Right.
        ///  Default value: [646 507] Identity: (null)
        @CIFilterValueBox var topRight: CIVector
        
        ///  The point in the input image to be mapped to the bottom right corner of the output image.
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Right.
        ///  Default value: [548 140] Identity: (null)
        @CIFilterValueBox var bottomRight: CIVector
        
        ///  The point in the input image to be mapped to the bottom left corner of the output image.
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Left.
        ///  Default value: [155 153] Identity: (null)
        @CIFilterValueBox var bottomLeft: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _topLeft.cofig(filter: filter, name: "inputTopLeft", default: .init(string: "CIVector"))
            _topRight.cofig(filter: filter, name: "inputTopRight", default: .init(string: "CIVector"))
            _bottomRight.cofig(filter: filter, name: "inputBottomRight", default: .init(string: "CIVector"))
            _bottomLeft.cofig(filter: filter, name: "inputBottomLeft", default: .init(string: "CIVector"))
        }
    }
    /**
     Discussion
     You can use the perspective filter to skew an image.
     */
    public struct PerspectiveTransform: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .perspectiveTransform)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Left.
        ///  Default value: [118 484]
        @CIFilterValueBox var topLeft: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Right.
        ///  Default value: [646 507]
        @CIFilterValueBox var topRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Right.
        ///  Default value: [548 140]
        @CIFilterValueBox var bottomRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Left.
        ///  Default value: [155 153]
        @CIFilterValueBox var bottomLeft: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _topLeft.cofig(filter: filter, name: "inputTopLeft", default: .init(string: "[118 484]"))
            _topRight.cofig(filter: filter, name: "inputTopRight", default: .init(string: "[646 507] "))
            _bottomRight.cofig(filter: filter, name: "inputBottomRight", default: .init(string: "[548 140]"))
            _bottomLeft.cofig(filter: filter, name: "inputBottomLeft", default: .init(string: "[155 153]"))
        }
    }
    /**
     Discussion
     You can use the perspective filter to skew an the portion of the image defined by extent. See CIPerspectiveTransform for an example of the output of this filter when you supply the input image size as the extent.
     */
    ///  Available in iOS 6.0 and later.
    public struct PerspectiveTransformWithExtent: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .perspectiveTransformWithExtent)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose whose attribute type is CIAttributeTypeRectangle. If you pass [image extent] you’ll get the same result as using the CIPerspectiveTransform filter.
        @CIFilterValueBox var extent: CIVector?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Left.
        ///  Default value: [118 484]
        @CIFilterValueBox var topLeft: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Right.
        ///  Default value: [646 507]
        @CIFilterValueBox var topRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Right.
        ///  Default value: [548 140]
        @CIFilterValueBox var bottomRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Left.
        ///  Default value: [155 153]
        @CIFilterValueBox var bottomLeft: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
            _topLeft.cofig(filter: filter, name: "inputTopLeft", default: .init(string: "[118 484]"))
            _topRight.cofig(filter: filter, name: "inputTopRight", default: .init(string: "[646 507] "))
            _bottomRight.cofig(filter: filter, name: "inputBottomRight", default: .init(string: "[548 140]"))
            _bottomLeft.cofig(filter: filter, name: "inputBottomLeft", default: .init(string: "[155 153]"))
        }
    }
    /**
     Discussion
     The image is scaled and cropped so that the rotated image fits the extent of the input image.
     */
    public struct StraightenFilter: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(geometryAdjustment: .straightenFilter)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }
    }
}
extension CIFilter {
    convenience init(gradient type: Gradient) {
        self.init(name: type.rawValue)!
    }
    public enum Gradient: String {
        case gaussianGradient = "CIGaussianGradient"
        case linearGradient = "CILinearGradient"
        case radialGradient = "CIRadialGradient"
        ///  Available in OS X v10.11 and later and in iOS 7.0 and later.
        case smoothLinearGradient = "CISmoothLinearGradient"
    }
}
extension CIFilter.Gradient {

    public struct GaussianGradient: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(gradient: .gaussianGradient)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150] Identity: (null)
        @CIFilterValueBox var center: CIVector
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox var color1: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 300.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 300.00)
        }
    }

    public struct LinearGradient: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(gradient: .linearGradient)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 1.
        ///  Default value: [0 0]
        @CIFilterValueBox var point0: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 2.
        ///  Default value: [200 200]
        @CIFilterValueBox var point1: CIVector
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox var color1: CIColor?
        
        init() {
            _point0.cofig(filter: filter, name: "inputPoint0", default: .init(string: "[0 0]"))
            _point1.cofig(filter: filter, name: "inputPoint1", default: .init(string: "[200 200]"))
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
        }
    }
    /**
     Discussion
     It is valid for one of the two circles to have a radius of 0.
     */
    public struct RadialGradient: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(gradient: .radialGradient)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius 1.
        ///  Default value: 5.00
        @CIFilterValueBox var radius0: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius 2.
        ///  Default value: 100.00
        @CIFilterValueBox var radius1: NSNumber
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox var color1: CIColor?
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _radius0.cofig(filter: filter, name: "inputRadius0", default: 5.00)
            _radius1.cofig(filter: filter, name: "inputRadius1", default: 100.00)
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
        }
    }
    /**
     Discussion
     Where the CILinearGradient filter blends colors linearly (that is, the color at a point 25% along the line between Point 1 and Point 2 is 25% Color 1 and 75% Color 2), this filter blends colors using an S-curve function: the color blend at points less than 50% along the line between Point 1 and Point 2 is slightly closer to Color 1 than in a linear blend, and the color blend at points further than 50% along that line is slightly closer to Color 2 than in a linear blend.
     */
    ///  Available in OS X v10.11 and later and in iOS 7.0 and later.
    public struct SmoothLinearGradient: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(gradient: .smoothLinearGradient)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 1.
        ///  Default value: [0 0]
        @CIFilterValueBox var point0: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Point 2.
        ///  Default value: [200 200]
        @CIFilterValueBox var point1: CIVector
        
        ///  A CIColor object whose attribute type is CIAttributeTypeColor and whose display name is Color 1.
        @CIFilterValueBox var color0: CIColor?
        
        ///  A CIColor object whose attribute type is CIAttributeTypeColor and whose display name is Color 2.
        @CIFilterValueBox var color1: CIColor?
        
        init() {
            _point0.cofig(filter: filter, name: "inputPoint0", default: .init(string: "[0 0] "))
            _point1.cofig(filter: filter, name: "inputPoint1", default: .init(string: "[200 200]"))
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
        }
    }
}
extension CIFilter {
    convenience init(halftoneEffect type: HalftoneEffect) {
        self.init(name: type.rawValue)!
    }
    public enum HalftoneEffect: String {
        case circularScreen = "CICircularScreen"
        ///   and later and in iOS 9 and later.
        case cMYKHalftone = "CICMYKHalftone"
        case dotScreen = "CIDotScreen"
        case hatchedScreen = "CIHatchedScreen"
        case lineScreen = "CILineScreen"
    }
}
extension CIFilter.HalftoneEffect {
    
    public struct CircularScreen: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(halftoneEffect: .circularScreen)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 6.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.70
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _width.cofig(filter: filter, name: "inputWidth", default: 6.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.70)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct CMYKHalftone: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(halftoneEffect: .cMYKHalftone)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 6.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.70
        @CIFilterValueBox var sharpness: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Gray Component Replacement.
        ///  Default value: 1.00
        @CIFilterValueBox var gCR: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Under Color Removal.
        ///  Default value: 0.50
        @CIFilterValueBox var uCR: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _width.cofig(filter: filter, name: "inputWidth", default: 6.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.70)
            _gCR.cofig(filter: filter, name: "inputGCR", default: 1.00)
            _uCR.cofig(filter: filter, name: "inputUCR", default: 0.50)
        }
    }

    public struct DotScreen: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(halftoneEffect: .dotScreen)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 6.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.70
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 6.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.70)
        }
    }

    public struct HatchedScreen: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(halftoneEffect: .hatchedScreen)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 6.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.70
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 6.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.70)
        }
    }

    public struct LineScreen: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(halftoneEffect: .lineScreen)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        @CIFilterValueBox var angle: NSNumber?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 6.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.70
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: nil)
            _width.cofig(filter: filter, name: "inputWidth", default: 6.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.70)
        }
    }
}
extension CIFilter {
    convenience init(reduction type: Reduction) {
        self.init(name: type.rawValue)!
    }
    public enum Reduction: String {
        ///   and later and in iOS 9 and later.
        case areaAverage = "CIAreaAverage"
        case areaHistogram = "CIAreaHistogram"
        ///   and later and in iOS 9 and later.
        case rowAverage = "CIRowAverage"
        ///   and later and in iOS 9 and later.
        case columnAverage = "CIColumnAverage"
        case histogramDisplayFilter = "CIHistogramDisplayFilter"
        /// and later and in iOS 9 and later.
        case areaMaximum = "CIAreaMaximum"
        ///   and later and in iOS 9 and later.
        case areaMinimum = "CIAreaMinimum"
        ///   and later and in iOS 9 and later.
        case areaMaximumAlpha = "CIAreaMaximumAlpha"
        ///   and later and in iOS 9 and later.
        case areaMinimumAlpha = "CIAreaMinimumAlpha"
    }
}
extension CIFilter.Reduction {
    
    ///   and later and in iOS 9 and later.
    public struct AreaAverage: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaAverage)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object representing the rectangular region of interest.
        @CIFilterValueBox var extent: CIVector?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }

    public struct AreaHistogram: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaHistogram)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        ///  The number of “buckets” for the histogram.
        @CIFilterValueBox var count: Any?
        
        ///  A scaling factor. Core Image scales the histogram by dividing the scale by the area of the inputExtent rectangle.
        @CIFilterValueBox var scale: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
            _count.cofig(filter: filter, name: "inputCount", default: nil)
            _scale.cofig(filter: filter, name: "inputScale", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct RowAverage: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .rowAverage)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct ColumnAverage: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .columnAverage)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
    /**
     Discussion
     The input image should be a one-dimensional image in which each pixel contains data (per component) for one “bucket” of the histogram; you can produce such an image using the CIAreaHistogram filter. The width of the output image is the same as that of the input image, and its height is the value of the inputHeight parameter.
     */
    public struct HistogramDisplayFilter: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .histogramDisplayFilter)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  The height of the displayable histogram image. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Height.
        ///  Default value: 100.00 Minimum: 1.00 Maximum: 200.00 Slider minimum: 1.00 Slider maximum: 100.00 Identity: 0.00
        @CIFilterValueBox var height: NSNumber
        
        ///  The fraction of the left portion of the histogram image to be made darker. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is HighLimit.
        ///  Default value: 1.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var highLimit: NSNumber
        
        ///  The fraction of the right portion of the histogram image to be made lighter. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is LowLimit.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var lowLimit: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _height.cofig(filter: filter, name: "inputHeight", default: 100.00)
            _highLimit.cofig(filter: filter, name: "inputHighLimit", default: 1.00)
            _lowLimit.cofig(filter: filter, name: "inputLowLimit", default: 0.00)
        }
    }
    /**
     Discussion
     Image component values should range from 0.0 to 1.0, inclusive.
     */
    /// and later and in iOS 9 and later.
    public struct AreaMaximum: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaMaximum)
        
        ///A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
    /**
     Discussion
     Image component values should range from 0.0 to 1.0, inclusive.
     */
    ///   and later and in iOS 9 and later.
    public struct AreaMinimum: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaMinimum)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
    /**
     Discussion
     If more than one pixel exists with the maximum alpha value, Core Image returns the vector that has the lowest x and y coordinate. Image component values should range from 0.0 to 1.0, inclusive.
     */
    ///   and later and in iOS 9 and later.
    public struct AreaMaximumAlpha: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaMaximumAlpha)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
    /**
     Discussion
     If more than one pixel exists with the minimum alpha value, Core Image returns the vector that has the lowest x and y coordinate. Image component values should range from 0.0 to 1.0, inclusive.
     */
    ///   and later and in iOS 9 and later.
    public struct AreaMinimumAlpha: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(reduction: .areaMinimumAlpha)
        
        ///  A CIImage object whose display name is Image. This is the image data you want to process.
        @CIFilterValueBox var image: CIImage?
        
        ///  The rectangular region of interest.
        @CIFilterValueBox var extent: Any?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: nil)
        }
    }
}
extension CIFilter {
    convenience init(sharpen type: Sharpen) {
        self.init(name: type.rawValue)!
    }
    public enum Sharpen: String {
        case sharpenLuminance = "CISharpenLuminance"
        case unsharpMask = "CIUnsharpMask"
    }
}
extension CIFilter.Sharpen {
    /**
     Discussion
     It operates on the luminance of the image; the chrominance of the pixels remains unaffected.
     */
    public struct SharpenLuminance: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(sharpen: .sharpenLuminance)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 0.40
        @CIFilterValueBox var sharpness: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 0.40)
        }
    }

    public struct UnsharpMask: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(sharpen: .unsharpMask)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 2.50
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 0.50
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 2.50)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 0.50)
        }
    }
}
extension CIFilter {
    convenience init(stylize type: Stylize) {
        self.init(name: type.rawValue)!
    }
    public enum Stylize: String {
        case blendWithAlphaMask = "CIBlendWithAlphaMask"
        case blendWithMask = "CIBlendWithMask"
        case bloom = "CIBloom"
        ///   and later and in iOS 9 and later.
        case comicEffect = "CIComicEffect"
        case convolution3X3 = "CIConvolution3X3"
        case convolution5X5 = "CIConvolution5X5"
        ///   and later and in iOS 9 and later.
        case convolution7X7 = "CIConvolution7X7"
        case convolution9Horizontal = "CIConvolution9Horizontal"
        case convolution9Vertical = "CIConvolution9Vertical"
        ///   and later and in iOS 9 and later.
        case crystallize = "CICrystallize"
        ///   and later and in iOS 9 and later.
        case depthOfField = "CIDepthOfField"
        ///   and later and in iOS 9 and later.
        case edges = "CIEdges"
        ///   and later and in iOS 9 and later.
        case edgeWork = "CIEdgeWork"
        case gloom = "CIGloom"
        ///   and later and in iOS 9 and later.
        case heightFieldFromMask = "CIHeightFieldFromMask"
        ///   and later and in iOS 9 and later.
        case hexagonalPixellate = "CIHexagonalPixellate"
        case highlightShadowAdjust = "CIHighlightShadowAdjust"
        ///   and later and in iOS 9 and later.
        case lineOverlay = "CILineOverlay"
        case pixellate = "CIPixellate"
        ///   and later and in iOS 9 and later.
        case pointillize = "CIPointillize"
        ///   and later and in iOS 9 and later.
        case shadedMaterial = "CIShadedMaterial"
        ///   and later and in iOS 9 and later.
        case spotColor = "CISpotColor"
        ///   and later and in iOS 9 and later.
        case spotLight = "CISpotLight"
    }
}
extension CIFilter.Stylize {
    /**
     Discussion
     When a mask alpha value is 0.0, the result is the background. When the mask alpha value is 1.0, the result is the image.
     */
    public struct BlendWithAlphaMask: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .blendWithAlphaMask)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        ///  A CIImage object whose display name is Mask Image.
        @CIFilterValueBox var maskImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
            _maskImage.cofig(filter: filter, name: "inputMaskImage", default: nil)
        }
    }
    /**
     Discussion
     When a mask value is 0.0, the result is the background. When the mask value is 1.0, the result is the image.
     */
    public struct BlendWithMask: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .blendWithMask)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Background Image.
        @CIFilterValueBox var backgroundImage: CIImage?
        
        ///  A CIImage object whose display name is Mask Image.
        @CIFilterValueBox var maskImage: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _backgroundImage.cofig(filter: filter, name: "inputBackgroundImage", default: nil)
            _maskImage.cofig(filter: filter, name: "inputMaskImage", default: nil)
        }
    }

    public struct Bloom: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .bloom)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 0.5
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 0.5)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct ComicEffect: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .comicEffect)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
        }
    }
    /**
     Discussion
     A convolution filter generates each output pixel by summing all elements in the element-wise product of two matrices—a weight matrix and a matrix containing the neighborhood surrounding the corresponding input pixel—and adding a bias. This operation is performed independently for each color component (including the alpha component), and the resulting value is clamped to the range between 0.0 and 1.0. You can create many types of image processing effects using different weight matrices, such as blurring, sharpening, edge detection, translation, and embossing.
     This filter uses a 3x3 weight matrix and the 3x3 neighborhood surrounding an input pixel (that is, the pixel itself and those within a distance of one pixel horizontally or vertically).
     If you want to preserve the overall brightness of the image, ensure that the sum of all values in the weight matrix is 1.0. You may find it convenient to devise a weight matrix without this constraint and then normalize it by dividing each element by the sum of all elements, as shown in the figure below.
     */
    public struct Convolution3X3: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .convolution3X3)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Weights.
        ///  Default value: [0 0 0 0 1 0 0 0 0] Identity: [0 0 0 0 1 0 0 0 0]
        @CIFilterValueBox var weights: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Bias.
        ///  Default value: 0.00 Identity: 0.00
        @CIFilterValueBox var bias: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _weights.cofig(filter: filter, name: "inputWeights", default: .init(string: "[0 0 0 0 1 0 0 0 0]"))
            _bias.cofig(filter: filter, name: "inputBias", default: 0.00)
        }
    }
    /**
     Discussion
     A convolution filter generates each output pixel by summing all elements in the element-wise product of two matrices—a weight matrix and a matrix containing the neighborhood surrounding the corresponding input pixel—and adding a bias. This operation is performed independently for each color component (including the alpha component), and the resulting value is clamped to the range between 0.0 and 1.0. You can create many types of image processing effects using different weight matrices, such as blurring, sharpening, edge detection, translation, and embossing.
     This filter uses a 5x5 weight matrix and the 5x5 neighborhood surrounding an input pixel (that is, the pixel itself and those within a distance of two pixels horizontally or vertically).
     If you want to preserve the overall brightness of the image, ensure that the sum of all values in the weight matrix is 1.0. You may find it convenient to devise a weight matrix without this constraint and then normalize it by dividing each element by the sum of all elements.
     */
    public struct Convolution5X5: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .convolution5X5)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Weights.
        ///  Default value: [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0] Identity: [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]
        @CIFilterValueBox var weights: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Bias.
        ///  Default value: 0.00 Identity: 0.00
        @CIFilterValueBox var bias: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _weights.cofig(filter: filter, name: "inputWeights", default: .init(string: "[0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]"))
            _bias.cofig(filter: filter, name: "inputBias", default: 0.00)
        }
    }
    /**
     Discussion
     A convolution filter generates each output pixel by summing all elements in the element-wise product of two matrices—a weight matrix and a matrix containing the neighborhood surrounding the corresponding input pixel—and adding a bias. This operation is performed independently for each color component (including the alpha component), and the resulting value is clamped to the range between 0.0 and 1.0. You can create many types of image processing effects using different weight matrices, such as blurring, sharpening, edge detection, translation, and embossing.
     This filter uses a 7x7 weight matrix and the 7x7 neighborhood surrounding an input pixel (that is, the pixel itself and those within a distance of three pixels horizontally or vertically).
     If you want to preserve the overall brightness of the image, ensure that the sum of all values in the weight matrix is 1.0. You may find it convenient to devise a weight matrix without this constraint and then normalize it by dividing each element by the sum of all elements.
     */
    ///   and later and in iOS 9 and later.
    public struct Convolution7X7: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .convolution7X7)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Weights.
        ///  Default value: [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        ///  Identity: [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        @CIFilterValueBox var weights: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Bias.
        ///  Default value: 0.00 Identity: 0.00
        @CIFilterValueBox var bias: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _weights.cofig(filter: filter, name: "inputWeights", default: .init(string: "[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] "))
            _bias.cofig(filter: filter, name: "inputBias", default: 0.00)
        }
    }
    /**
     Discussion
     A convolution filter generates each output pixel by summing all elements in the element-wise product of two matrices—a weight matrix and a matrix containing the neighborhood surrounding the corresponding input pixel—and adding a bias. This operation is performed independently for each color component (including the alpha component), and the resulting value is clamped to the range between 0.0 and 1.0. You can create many types of image processing effects using different weight matrices, such as blurring, sharpening, edge detection, translation, and embossing.
     This filter uses a 9x1 weight matrix and the 9x1 neighborhood surrounding an input pixel (that is, the pixel itself and those within a distance of four pixels horizontally). Unlike convolution filters which use square matrices, this filter can only produce effects along a horizontal axis, but it can be combined with CIConvolution9Vertical to approximate the effect of certain 9x9 weight matrices.
     If you want to preserve the overall brightness of the image, ensure that the sum of all values in the weight matrix is 1.0. You may find it convenient to devise a weight matrix without this constraint and then normalize it by dividing each element by the sum of all elements.
     */
    public struct Convolution9Horizontal: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .convolution9Horizontal)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Weights.
        ///  Default value: [0 0 0 0 1 0 0 0 0] Identity: [0 0 0 0 1 0 0 0 0]
        @CIFilterValueBox var weights: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Bias.
        ///  Default value: 0.00 Identity: 0.00
        @CIFilterValueBox var bias: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _weights.cofig(filter: filter, name: "inputWeights", default: .init(string: "[0 0 0 0 1 0 0 0 0]"))
            _bias.cofig(filter: filter, name: "inputBias", default: 0.00)
        }
    }
    /**
     Discussion
     A convolution filter generates each output pixel by summing all elements in the element-wise product of two matrices—a weight matrix and a matrix containing the neighborhood surrounding the corresponding input pixel—and adding a bias. This operation is performed independently for each color component (including the alpha component), and the resulting value is clamped to the range between 0.0 and 1.0. You can create many types of image processing effects using different weight matrices, such as blurring, sharpening, edge detection, translation, and embossing.
     This filter uses a 1x9 weight matrix and the 1x9 neighborhood surrounding an input pixel (that is, the pixel itself and those within a distance of four pixels vertically). Unlike convolution filters which use square matrices, this filter can only produce effects along a vertical axis, but it can be combined with CIConvolution9Vertical to approximate the effect of certain 9x9 weight matrices.
     If you want to preserve the overall brightness of the image, ensure that the sum of all values in the weight matrix is 1.0. You may find it convenient to devise a weight matrix without this constraint and then normalize it by dividing each element by the sum of all elements.
     */
    public struct Convolution9Vertical: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .convolution9Vertical)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose display name is Weights.
        ///  Default value: [0 0 0 0 1 0 0 0 0] Identity: [0 0 0 0 1 0 0 0 0]
        @CIFilterValueBox var weights: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Bias.
        ///  Default value: 0.00 Identity: 0.00
        @CIFilterValueBox var bias: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _weights.cofig(filter: filter, name: "inputWeights", default: .init(string: "[0 0 0 0 1 0 0 0 0]"))
            _bias.cofig(filter: filter, name: "inputBias", default: 0.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct Crystallize: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .crystallize)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 20.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 20.00)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct DepthOfField: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .depthOfField)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  The focused region of the image stretches in a line between inputPoint0 and inputPoint1 of the image. A CIVector object whose attribute type is CIAttributeTypePosition.
        @CIFilterValueBox var point0: CIVector?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition.
        @CIFilterValueBox var point1: CIVector?
        
        ///  A saturation effect applied to the in-focus regions of the image. An NSNumber object whose attribute type is CIAttributeTypeScalar. This value indications the amount to adjust the saturation on the in-focus portion of the image.
        @CIFilterValueBox var saturation: NSNumber?
        
        ///  Specifies the radius of the unsharp mask effect applied to the in-focus area. An NSNumber object whose attribute type is CIAttributeTypeScalar.
        @CIFilterValueBox var unsharpMaskRadius: NSNumber?
        
        ///  Specifies the intensity of the unsharp mask effect applied to the in-focus area. An NSNumber object whose attribute type is CIAttributeTypeScalar.
        @CIFilterValueBox var unsharpMaskIntensity: NSNumber?
        
        ///  Controls how much the out-of-focus regions are blurred. An NSNumber object whose attribute type is CIAttributeTypeScalar. This value specifies the distance from the center of the effect.
        @CIFilterValueBox var radius: NSNumber?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _point0.cofig(filter: filter, name: "inputPoint0", default: nil)
            _point1.cofig(filter: filter, name: "inputPoint1", default: nil)
            _saturation.cofig(filter: filter, name: "inputSaturation", default: nil)
            _unsharpMaskRadius.cofig(filter: filter, name: "inputUnsharpMaskRadius", default: nil)
            _unsharpMaskIntensity.cofig(filter: filter, name: "inputUnsharpMaskIntensity", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct Edges: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .edges)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 1.00
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 1.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct EdgeWork: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .edgeWork)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 3.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 3.00)
        }
    }

    public struct Gloom: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .gloom)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Intensity.
        ///  Default value: 0.5
        @CIFilterValueBox var intensity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
            _intensity.cofig(filter: filter, name: "inputIntensity", default: 0.5)
        }
    }
    /**
     Discussion
     The white values of the mask define those pixels that are inside the height field while the black values define those pixels that are outside. The field varies smoothly and continuously inside the mask, reaching the value 0 at the edge of the mask. You can use this filter with the CIShadedMaterial filter to produce extremely realistic shaded objects.
     */
    ///   and later and in iOS 9 and later.
    public struct HeightFieldFromMask: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .heightFieldFromMask)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 10.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 10.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct HexagonalPixellate: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .hexagonalPixellate)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Scale.
        ///  Default value: 8.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _scale.cofig(filter: filter, name: "inputScale", default: 8.00)
        }
    }

    public struct HighlightShadowAdjust: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .highlightShadowAdjust)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Highlight Amount.
        ///  Default value: 1.00
        @CIFilterValueBox var highlightAmount: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Shadow Amount.
        @CIFilterValueBox var shadowAmount: NSNumber?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _highlightAmount.cofig(filter: filter, name: "inputHighlightAmount", default: 1.00)
            _shadowAmount.cofig(filter: filter, name: "inputShadowAmount", default: nil)
        }
    }
    /**
     Discussion
     The portions of the image that are not outlined are transparent.
     */
    ///   and later and in iOS 9 and later.
    public struct LineOverlay: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .lineOverlay)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is NR Noise Level.
        ///  Default value: 0.07
        @CIFilterValueBox var nRNoiseLevel: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is NR Sharpness.
        ///  Default value: 0.71
        @CIFilterValueBox var nRSharpness: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Edge Intensity.
        ///  Default value: 1.00
        @CIFilterValueBox var edgeIntensity: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Threshold.
        ///  Default value: 0.10 Minimum: 0.00 Maximum: 0.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var threshold: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast.
        ///  Default value: 50.00
        @CIFilterValueBox var contrast: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _nRNoiseLevel.cofig(filter: filter, name: "inputNRNoiseLevel", default: 0.07)
            _nRSharpness.cofig(filter: filter, name: "inputNRSharpness", default: 0.71)
            _edgeIntensity.cofig(filter: filter, name: "inputEdgeIntensity", default: 1.00)
            _threshold.cofig(filter: filter, name: "inputThreshold", default: 0.10)
            _contrast.cofig(filter: filter, name: "inputContrast", default: 50.00)
        }
    }

    public struct Pixellate: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .pixellate)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Scale.
        ///  Default value: 8.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _scale.cofig(filter: filter, name: "inputScale", default: 8.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct Pointillize: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .pointillize)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 20.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 20.00)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
        }
    }
    /**
     Discussion
     The height field is defined to have greater heights with lighter shades, and lesser heights (lower areas) with darker shades. You can combine this filter with the CIHeightFieldFromMask filter to produce quick shadings of masks, such as text.
     This filter sets the input image as a height-field (multiplied by the scale parameter), and computes a normal vector for each pixel. It then uses that normal vector to look up the reflected color for that direction in the input shading image.
     The input shading image contains the picture of a hemisphere, which defines the way the surface is shaded. The look-up coordinate for a normal vector is:
     (normal.xy + 1.0) * 0.5 * vec2(shadingImageWidth, shadingImageHeight)
     */
    ///   and later and in iOS 9 and later.
    public struct ShadedMaterial: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .shadedMaterial)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Shading Image.
        @CIFilterValueBox var shadingImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Scale.
        ///  Default value: 10.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _shadingImage.cofig(filter: filter, name: "inputShadingImage", default: nil)
            _scale.cofig(filter: filter, name: "inputScale", default: 10.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct SpotColor: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .spotColor)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIColor object whose display name is Center Color 1.
        @CIFilterValueBox var centerColor1: CIColor?
        
        ///  A CIColor object whose display name is Replacement Color 1.
        @CIFilterValueBox var replacementColor1: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Closeness1.
        ///  Default value: 0.22
        @CIFilterValueBox var closeness1: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast 1.
        ///  Default value: 0.98
        @CIFilterValueBox var contrast1: NSNumber
        
        ///  A CIColor object whose display name is Center Color 2.
        @CIFilterValueBox var centerColor2: CIColor?
        
        ///  A CIColor object whose display name is Replacement Color 2.
        @CIFilterValueBox var replacementColor2: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Closeness 2.
        ///  Default value: 0.15
        @CIFilterValueBox var closeness2: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast 2.
        ///  Default value: 0.98
        @CIFilterValueBox var contrast2: NSNumber
        
        ///  A CIColor object whose display name is Center Color 3.
        @CIFilterValueBox var centerColor3: CIColor?
        
        ///  A CIColor object whose display name is Replacement Color 3.
        @CIFilterValueBox var replacementColor3: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Closeness 3.
        ///  Default value: 0.50
        @CIFilterValueBox var closeness3: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Contrast 3.
        ///  Default value: 0.99
        @CIFilterValueBox var contrast3: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _centerColor1.cofig(filter: filter, name: "inputCenterColor1", default: nil)
            _replacementColor1.cofig(filter: filter, name: "inputReplacementColor1", default: nil)
            _closeness1.cofig(filter: filter, name: "inputCloseness1", default: 0.22)
            _contrast1.cofig(filter: filter, name: "inputContrast1", default: 0.98)
            _centerColor2.cofig(filter: filter, name: "inputCenterColor2", default: nil)
            _replacementColor2.cofig(filter: filter, name: "inputReplacementColor2", default: nil)
            _closeness2.cofig(filter: filter, name: "inputCloseness2", default: 0.15)
            _contrast2.cofig(filter: filter, name: "inputContrast2", default: 0.98)
            _centerColor3.cofig(filter: filter, name: "inputCenterColor3", default: nil)
            _replacementColor3.cofig(filter: filter, name: "inputReplacementColor3", default: nil)
            _closeness3.cofig(filter: filter, name: "inputCloseness3", default: 0.50)
            _contrast3.cofig(filter: filter, name: "inputContrast3", default: 0.99)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct SpotLight: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(stylize: .spotLight)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition3 and whose display name is Light Position.
        ///  Default value: [400 600 150]
        @CIFilterValueBox var lightPosition: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition3 and whose display name is Light Points At.
        ///  Default value: [200 200 0]
        @CIFilterValueBox var lightPointsAt: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Brightness.
        ///  Default value: 3.00
        @CIFilterValueBox var brightness: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Concentration.
        ///  Default value: 0.10
        @CIFilterValueBox var concentration: NSNumber
        
        ///  A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _lightPosition.cofig(filter: filter, name: "inputLightPosition", default: .init(string: "[400 600 150]"))
            _lightPointsAt.cofig(filter: filter, name: "inputLightPointsAt", default: .init(string: "[200 200 0]"))
            _brightness.cofig(filter: filter, name: "inputBrightness", default: 3.00)
            _concentration.cofig(filter: filter, name: "inputConcentration", default: 0.10)
            _color.cofig(filter: filter, name: "inputColor", default: nil)
        }
    }
}
extension CIFilter {
    convenience init(tileEffect type: TileEffect) {
        self.init(name: type.rawValue)!
    }
    public enum TileEffect: String {
        case affineClamp = "CIAffineClamp"
        case affineTile = "CIAffineTile"
        case eightfoldReflectedTile = "CIEightfoldReflectedTile"
        case fourfoldReflectedTile = "CIFourfoldReflectedTile"
        case fourfoldRotatedTile = "CIFourfoldRotatedTile"
        case fourfoldTranslatedTile = "CIFourfoldTranslatedTile"
        case glideReflectedTile = "CIGlideReflectedTile"
        ///   and later and in iOS 9 and later.
        case kaleidoscope = "CIKaleidoscope"
        ///   and later and in iOS 9 and later.
        case opTile = "CIOpTile"
        ///   and later and in iOS 9 and later.
        case parallelogramTile = "CIParallelogramTile"
        case perspectiveTile = "CIPerspectiveTile"
        case sixfoldReflectedTile = "CISixfoldReflectedTile"
        case sixfoldRotatedTile = "CISixfoldRotatedTile"
        ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
        case triangleKaleidoscope = "CITriangleKaleidoscope"
        ///   and later and in iOS 9 and later.
        case triangleTile = "CITriangleTile"
        case twelvefoldReflectedTile = "CITwelvefoldReflectedTile"
    }
}
extension CIFilter.TileEffect {
    /**
     Discussion
     This filter performs similarly to the CIAffineTransform filter except that it produces an image with infinite extent. You can use this filter when you need to blur an image but you want to avoid a soft, black fringe along the edges.
     */
    public struct AffineClamp: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .affineClamp)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  On iOS, an NSValue object whose attribute type is CIAttributeTypeTransform. You must pass the transform as NSData using a statement similar to the following, where xform is an affine transform:
        ///
        ///
        ///            [myFilter setValue:[NSValue valueWithBytes:&xform
        ///                                              objCType:@encode(CGAffineTransform)]
        ///                        forKey:@"inputTransform"];
        ///
        ///
        ///  On OS X, an NSAffineTransform object whose attribute type is CIAttributeTypeTransform.
        @CIFilterValueBox var transform: NSValue?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _transform.cofig(filter: filter, name: "inputTransform", default: nil)
        }
    }

    public struct AffineTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .affineTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  On iOS, an NSValue object whose attribute type is CIAttributeTypeTransform. You must pass the transform as NSData using a statement similar to the following, where xform is an affine transform:
        ///
        ///
        ///            [myFilter setValue:[NSValue valueWithBytes:&xform
        ///                                              objCType:@encode(CGAffineTransform)]
        ///                        forKey:@"inputTransform"];
        ///
        ///
        ///  On OS X, an NSAffineTransform object whose attribute type is CIAttributeTypeTransform.
        @CIFilterValueBox var transform: NSValue?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _transform.cofig(filter: filter, name: "inputTransform", default: nil)
        }
    }

    public struct EightfoldReflectedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .eightfoldReflectedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct FourfoldReflectedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .fourfoldReflectedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Acute Angle.
        ///  Default value: 1.57
        @CIFilterValueBox var acuteAngle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _acuteAngle.cofig(filter: filter, name: "inputAcuteAngle", default: 1.57)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct FourfoldRotatedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .fourfoldRotatedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct FourfoldTranslatedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .fourfoldTranslatedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Acute Angle.
        ///  Default value: 1.57
        @CIFilterValueBox var acuteAngle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _acuteAngle.cofig(filter: filter, name: "inputAcuteAngle", default: 1.57)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct GlideReflectedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .glideReflectedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct Kaleidoscope: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .kaleidoscope)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Count.
        ///  Default value: 6.00
        @CIFilterValueBox var count: NSNumber
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _count.cofig(filter: filter, name: "inputCount", default: 6.00)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct OpTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .opTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 2.80
        @CIFilterValueBox var scale: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 65.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _scale.cofig(filter: filter, name: "inputScale", default: 2.80)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 65.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct ParallelogramTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .parallelogramTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Acute Angle.
        ///  Default value: 1.57
        @CIFilterValueBox var acuteAngle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _acuteAngle.cofig(filter: filter, name: "inputAcuteAngle", default: 1.57)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct PerspectiveTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .perspectiveTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Left.
        ///  Default value: [118 484]
        @CIFilterValueBox var topLeft: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Top Right.
        ///  Default value: [646 507]
        @CIFilterValueBox var topRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Right.
        ///  Default value: [548 140]
        @CIFilterValueBox var bottomRight: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Bottom Left.
        ///  Default value: [155 153]
        @CIFilterValueBox var bottomLeft: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _topLeft.cofig(filter: filter, name: "inputTopLeft", default: .init(string: "[118 484]"))
            _topRight.cofig(filter: filter, name: "inputTopRight", default: .init(string: "[646 507]"))
            _bottomRight.cofig(filter: filter, name: "inputBottomRight", default: .init(string: "[548 140]"))
            _bottomLeft.cofig(filter: filter, name: "inputBottomLeft", default: .init(string: "[155 153]"))
        }
    }

    public struct SixfoldReflectedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .sixfoldReflectedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct SixfoldRotatedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .sixfoldRotatedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }
    
    ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
    public struct TriangleKaleidoscope: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .triangleKaleidoscope)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition.
        ///  Default value: [150 150]
        @CIFilterValueBox var point: CIVector
        
        ///  A NSNumber object whose attribute type is CIAttributeTypeScalar.
        ///  Default value: 700.00
        @CIFilterValueBox var size: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle.
        ///  Default value: –0.36
        @CIFilterValueBox var rotation: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar.
        ///  Default: 0.85
        @CIFilterValueBox var decay: NSNumber?
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _point.cofig(filter: filter, name: "inputPoint", default: .init(string: "[150 150]"))
            _size.cofig(filter: filter, name: "inputSize", default: 700.00)
            _rotation.cofig(filter: filter, name: "inputRotation", default: -0.36)
            _decay.cofig(filter: filter, name: "inputDecay", default: nil)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct TriangleTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .triangleTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }

    public struct TwelvefoldReflectedTile: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(tileEffect: .twelvefoldReflectedTile)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  The width, along with the inputCenter parameter, defines the portion of the image to tile. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
        }
    }
}
extension CIFilter {
    convenience init(transition type: Transition) {
        self.init(name: type.rawValue)!
    }
    public enum Transition: String {
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case accordionFoldTransition = "CIAccordionFoldTransition"
        case barsSwipeTransition = "CIBarsSwipeTransition"
        case copyMachineTransition = "CICopyMachineTransition"
        case disintegrateWithMaskTransition = "CIDisintegrateWithMaskTransition"
        case dissolveTransition = "CIDissolveTransition"
        case flashTransition = "CIFlashTransition"
        case modTransition = "CIModTransition"
        ///   and later and in iOS 9 and later.
        case pageCurlTransition = "CIPageCurlTransition"
        ///   and later and in iOS 9 and later.
        case pageCurlWithShadowTransition = "CIPageCurlWithShadowTransition"
        ///   and later and in iOS 9 and later.
        case rippleTransition = "CIRippleTransition"
        case swipeTransition = "CISwipeTransition"
    }
}
extension CIFilter.Transition {
    
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    public struct AccordionFoldTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .accordionFoldTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is BottomHeight.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 0.00 Slider minimum: 0.00 Slider maximum: 0.00 Identity: 0.00
        @CIFilterValueBox var bottomHeight: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is NumberOfFolds.
        ///  Default value: 3.00 Minimum: 1.00 Maximum: 50.00 Slider minimum: 1.00 Slider maximum: 10.00 Identity: 0.00
        @CIFilterValueBox var numberOfFolds: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is FoldShadowAmount.
        ///  Default value: 0.10 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var foldShadowAmount: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var time: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _bottomHeight.cofig(filter: filter, name: "inputBottomHeight", default: 0.00)
            _numberOfFolds.cofig(filter: filter, name: "inputNumberOfFolds", default: 3.00)
            _foldShadowAmount.cofig(filter: filter, name: "inputFoldShadowAmount", default: 0.10)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
        }
    }

    public struct BarsSwipeTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .barsSwipeTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 3.14
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 30.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Bar Offset.
        ///  Default value: 10.00
        @CIFilterValueBox var barOffset: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _angle.cofig(filter: filter, name: "inputAngle", default: 3.14)
            _width.cofig(filter: filter, name: "inputWidth", default: 30.00)
            _barOffset.cofig(filter: filter, name: "inputBarOffset", default: 10.00)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
        }
    }

    public struct CopyMachineTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .copyMachineTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var extent: CIVector
        
        ///  A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 200.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Opacity.
        ///  Default value: 1.30
        @CIFilterValueBox var opacity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 300 300]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 200.00)
            _opacity.cofig(filter: filter, name: "inputOpacity", default: 1.30)
        }
    }

    public struct DisintegrateWithMaskTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .disintegrateWithMaskTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIImage object whose display name is Mask Image.
        @CIFilterValueBox var maskImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Shadow Radius.
        ///  Default value: 8.00
        @CIFilterValueBox var shadowRadius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Shadow Density.
        ///  Default value: 0.65
        @CIFilterValueBox var shadowDensity: NSNumber
        
        ///  A CIVector object whose attribute type is CIAttributeTypeOffset and whose display name is Shadow Offset.
        ///  Default value: [0 -10]
        @CIFilterValueBox var shadowOffset: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _maskImage.cofig(filter: filter, name: "inputMaskImage", default: nil)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _shadowRadius.cofig(filter: filter, name: "inputShadowRadius", default: 8.00)
            _shadowDensity.cofig(filter: filter, name: "inputShadowDensity", default: 0.65)
            _shadowOffset.cofig(filter: filter, name: "inputShadowOffset", default: .init(string: "[0 -10] "))
        }
    }

    public struct DissolveTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .dissolveTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
        }
    }
    /**
     Discussion
     The flash originates from a point you specify. Small at first, it rapidly expands until the image frame is completely filled with the flash color. As the color fades, the target image begins to appear.
     */
    public struct FlashTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .flashTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var extent: CIVector
        
        ///  A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Maximum Striation Radius.
        ///  Default value: 2.58
        @CIFilterValueBox var maxStriationRadius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Strength.
        ///  Default value: 0.50
        @CIFilterValueBox var striationStrength: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Contrast.
        ///  Default value: 1.38
        @CIFilterValueBox var striationContrast: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Fade Threshold.
        ///  Default value: 0.85
        @CIFilterValueBox var fadeThreshold: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 300 300]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _maxStriationRadius.cofig(filter: filter, name: "inputMaxStriationRadius", default: 2.58)
            _striationStrength.cofig(filter: filter, name: "inputStriationStrength", default: 0.50)
            _striationContrast.cofig(filter: filter, name: "inputStriationContrast", default: 1.38)
            _fadeThreshold.cofig(filter: filter, name: "inputFadeThreshold", default: 0.85)
        }
    }

    public struct ModTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .modTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 2.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 150.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Compression.
        ///  Default value: 300.00
        @CIFilterValueBox var compression: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 2.00)
            _radius.cofig(filter: filter, name: "inputRadius", default: 150.00)
            _compression.cofig(filter: filter, name: "inputCompression", default: 300.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct PageCurlTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .pageCurlTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIImage object whose display name is Backside Image.
        @CIFilterValueBox var backsideImage: CIImage?
        
        ///  A CIImage object whose display name is Shading Image.
        @CIFilterValueBox var shadingImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var extent: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 100.00
        @CIFilterValueBox var radius: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _backsideImage.cofig(filter: filter, name: "inputBacksideImage", default: nil)
            _shadingImage.cofig(filter: filter, name: "inputShadingImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 300 300]"))
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _radius.cofig(filter: filter, name: "inputRadius", default: 100.00)
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct PageCurlWithShadowTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .pageCurlWithShadowTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIImage object whose display name is Backside Image.
        @CIFilterValueBox var backsideImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 0 0] Identity: (null)
        @CIFilterValueBox var extent: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 0.00 Slider minimum: -3.14 Slider maximum: 3.14 Identity: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 100.00 Minimum: 0.01 Maximum: 0.00 Slider minimum: 0.01 Slider maximum: 400.00 Identity: 0.00
        @CIFilterValueBox var radius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is ShadowSize.
        ///  Default value: 0.50 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var shadowSize: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is ShadowAmount.
        ///  Default value: 0.70 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox var shadowAmount: NSNumber
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is ShadowExtent.
        ///  Default value: [0 0 0 0] Identity: (null)
        @CIFilterValueBox var shadowExtent: CIVector
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _backsideImage.cofig(filter: filter, name: "inputBacksideImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 0 0]"))
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _radius.cofig(filter: filter, name: "inputRadius", default: 100.00)
            _shadowSize.cofig(filter: filter, name: "inputShadowSize", default: 0.50)
            _shadowAmount.cofig(filter: filter, name: "inputShadowAmount", default: 0.70)
            _shadowExtent.cofig(filter: filter, name: "inputShadowExtent", default: .init(string: "[0 0 0 0]"))
        }
    }
    
    ///   and later and in iOS 9 and later.
    public struct RippleTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .rippleTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIImage object whose display name is Shading Image.
        @CIFilterValueBox var shadingImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox var center: CIVector
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var extent: CIVector
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 100.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Scale.
        ///  Default value: 50.00
        @CIFilterValueBox var scale: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _shadingImage.cofig(filter: filter, name: "inputShadingImage", default: nil)
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 300 300]"))
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 100.00)
            _scale.cofig(filter: filter, name: "inputScale", default: 50.00)
        }
    }

    public struct SwipeTransition: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(transition: .swipeTransition)
        
        ///  A CIImage object whose display name is Image.
        @CIFilterValueBox var image: CIImage?
        
        ///  A CIImage object whose display name is Target Image.
        @CIFilterValueBox var targetImage: CIImage?
        
        ///  A CIVector object whose attribute type is CIAttributeTypeRectangle and whose display name is Extent.
        ///  Default value: [0 0 300 300]
        @CIFilterValueBox var extent: CIVector
        
        ///  A CIColor object whose attribute type is CIAttributeTypeOpaqueColor and whose display name is Color.
        @CIFilterValueBox var color: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeTime and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox var time: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Angle.
        ///  Default value: 0.00
        @CIFilterValueBox var angle: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 300.00
        @CIFilterValueBox var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Opacity.
        ///  Default value: 0.00
        @CIFilterValueBox var opacity: NSNumber
        
        init() {
            _image.cofig(filter: filter, name: "inputImage", default: nil)
            _targetImage.cofig(filter: filter, name: "inputTargetImage", default: nil)
            _extent.cofig(filter: filter, name: "inputExtent", default: .init(string: "[0 0 300 300]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
            _angle.cofig(filter: filter, name: "inputAngle", default: 0.00)
            _width.cofig(filter: filter, name: "inputWidth", default: 300.00)
            _opacity.cofig(filter: filter, name: "inputOpacity", default: 0.00)
        }
    }
}
