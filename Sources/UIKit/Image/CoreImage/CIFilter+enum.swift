//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import CoreImage

public protocol CIFilterContainerProtocol {
    var filter: CIFilter { get }
}

public extension CIFilterContainerProtocol {

    var outputImage: CIImage? {
        return filter.outputImage
    }

    var name: String {
        return filter.name
    }

    func setDefaults() {
        return filter.setDefaults()
    }

    var attributes: [String: Any] {
        return filter.attributes
    }
}

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
public extension CIFilter {

    convenience init(blur value: CIFilter.Blur) {
        self.init(name: value.rawValue)!
    }

    convenience init(colorAdjustment value: CIFilter.ColorAdjustment) {
        self.init(name: value.rawValue)!
    }

    convenience init(colorEffect value: CIFilter.ColorEffect) {
        self.init(name: value.rawValue)!
    }

    convenience init(compositeOperation value: CIFilter.CompositeOperation) {
        self.init(name: value.rawValue)!
    }

    convenience init(distortionEffect value: CIFilter.DistortionEffect) {
        self.init(name: value.rawValue)!
    }

    convenience init(generator value: CIFilter.Generator) {
        self.init(name: value.rawValue)!
    }

    convenience init(geometryAdjustment value: CIFilter.GeometryAdjustment) {
        self.init(name: value.rawValue)!
    }

    convenience init(gradient value: CIFilter.Gradient) {
        self.init(name: value.rawValue)!
    }

    convenience init(halftoneEffect value: CIFilter.HalftoneEffect) {
        self.init(name: value.rawValue)!
    }

    convenience init(reduction value: CIFilter.Reduction) {
        self.init(name: value.rawValue)!
    }

    convenience init(sharpen value: CIFilter.Sharpen) {
        self.init(name: value.rawValue)!
    }

    convenience init(stylize value: CIFilter.Stylize) {
        self.init(name: value.rawValue)!
    }

    convenience init(tileEffect value: CIFilter.TileEffect) {
        self.init(name: value.rawValue)!
    }

    convenience init(transition value: CIFilter.Transition) {
        self.init(name: value.rawValue)!
    }

}

public extension CIFilter {

    enum Blur: String {
        case boxBlur            = "CIBoxBlur"
        case discBlur           = "CIDiscBlur"
        case gaussianBlur       = "CIGaussianBlur"
        case maskedVariableBlur = "CIMaskedVariableBlur"
        case medianFilter       = "CIMedianFilter"
        case motionBlur         = "CIMotionBlur"
        case noiseReduction     = "CINoiseReduction"
    }

    enum ColorAdjustment: String {
        case colorClamp            = "CIColorClamp"
        case colorControls         = "CIColorControls"
        case colorMatrix           = "CIColorMatrix"
        case colorPolynomial       = "CIColorPolynomial"
        case exposureAdjust        = "CIExposureAdjust"
        case gammaAdjust           = "CIGammaAdjust"
        case hueAdjust             = "CIHueAdjust"
        case linearToSRGBToneCurve = "CILinearToSRGBToneCurve"
        case sRGBToneCurveToLinear = "CISRGBToneCurveToLinear"
        case temperatureAndTint    = "CITemperatureAndTint"
        case toneCurve             = "CIToneCurve"
        case vibrance              = "CIVibrance"
        case whitePointAdjust      = "CIWhitePointAdjust"
    }

    enum ColorEffect: String {
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

    enum CompositeOperation: String {
        case additionCompositing   = "CIAdditionCompositing"
        case colorBlendMode        = "CIColorBlendMode"
        case colorBurnBlendMode    = "CIColorBurnBlendMode"
        case colorDodgeBlendMode   = "CIColorDodgeBlendMode"
        case darkenBlendMode       = "CIDarkenBlendMode"
        case differenceBlendMode   = "CIDifferenceBlendMode"
        case divideBlendMode       = "CIDivideBlendMode"
        case exclusionBlendMode    = "CIExclusionBlendMode"
        case hardLightBlendMode    = "CIHardLightBlendMode"
        case hueBlendMode          = "CIHueBlendMode"
        case lightenBlendMode      = "CILightenBlendMode"
        case linearBurnBlendMode   = "CILinearBurnBlendMode"
        case linearDodgeBlendMode  = "CILinearDodgeBlendMode"
        case luminosityBlendMode   = "CILuminosityBlendMode"
        case maximumCompositing    = "CIMaximumCompositing"
        case minimumCompositing    = "CIMinimumCompositing"
        case multiplyBlendMode     = "CIMultiplyBlendMode"
        case multiplyCompositing   = "CIMultiplyCompositing"
        case overlayBlendMode      = "CIOverlayBlendMode"
        case pinLightBlendMode     = "CIPinLightBlendMode"
        case saturationBlendMode   = "CISaturationBlendMode"
        case screenBlendMode       = "CIScreenBlendMode"
        case softLightBlendMode    = "CISoftLightBlendMode"
        case sourceAtopCompositing = "CISourceAtopCompositing"
        case sourceInCompositing   = "CISourceInCompositing"
        case sourceOutCompositing  = "CISourceOutCompositing"
        case sourceOverCompositing = "CISourceOverCompositing"
        case subtractBlendMode     = "CISubtractBlendMode"
    }

    enum DistortionEffect: String {
        case bumpDistortion         = "CIBumpDistortion"
        case bumpDistortionLinear   = "CIBumpDistortionLinear"
        case circleSplashDistortion = "CICircleSplashDistortion"
        case circularWrap           = "CICircularWrap"
        case droste                 = "CIDroste"
        case displacementDistortion = "CIDisplacementDistortion"
        case glassDistortion        = "CIGlassDistortion"
        case glassLozenge           = "CIGlassLozenge"
        case holeDistortion         = "CIHoleDistortion"
        case lightTunnel            = "CILightTunnel"
        case pinchDistortion        = "CIPinchDistortion"
        case stretchCrop            = "CIStretchCrop"
        case torusLensDistortion    = "CITorusLensDistortion"
        case twirlDistortion        = "CITwirlDistortion"
        case vortexDistortion       = "CIVortexDistortion"
    }

    enum Generator: String {

        /// 二维码
        public class QRCode: CIFilterContainerProtocol {
            /// 纠错等级
            public enum CorrectionLevel: String {
                /// 7%
                case l = "L"
                /// 15%
                case m = "M"
                /// 25%
                case q = "Q"
                /// 30%
                case h = "H"
            }

            public let filter = CIFilter(name: "CIQRCodeGenerator")!

            /// 要编码为QR码的数据
            public var message: Data? {
                get { return filter.value(forKey: "inputMessage") as? Data }
                set { filter.setValue(newValue, forKey: "inputMessage") }
            }

            /// 纠错等级
            public var correctionLevel: CorrectionLevel {
                get {
                    guard let value = filter.value(forKey: "inputCorrectionLevel") as? String else { return .m }
                    return CIFilter.Generator.QRCode.CorrectionLevel(rawValue: value)  ?? .m
                }
                set { filter.setValue(newValue.rawValue, forKey: "inputCorrectionLevel") }
            }
        }

        case aztecCodeGenerator      = "CIAztecCodeGenerator"
        case checkerboardGenerator   = "CICheckerboardGenerator"
        case codest8CarcodeGenerator = "CICodest8CarcodeGenerator"
        case constantColorGenerator  = "CIConstantColorGenerator"
        case lenticularHaloGenerator = "CILenticularHaloGenerator"
        case pDF417BarcodeGenerator  = "CIPDF417BarcodeGenerator"
        case qRCodeGenerator         = "CIQRCodeGenerator"
        case randomGenerator         = "CIRandomGenerator"
        case starShineGenerator      = "CIStarShineGenerator"
        case stripesGenerator        = "CIStripesGenerator"
        case sunbeamsGenerator       = "CISunbeamsGenerator"
    }

    enum GeometryAdjustment: String {
        case affineTransform                = "CIAffineTransform"
        case crop                           = "CICrop"
        case lanczosScaleTransform          = "CILanczosScaleTransform"
        case perspectiveCorrection          = "CIPerspectiveCorrection"
        case perspectiveTransform           = "CIPerspectiveTransform"
        case perspectiveTransformWithExtent = "CIPerspectiveTransformWithExtent"
        case straightenFilter               = "CIStraightenFilter"
    }

    enum Gradient: String {
        case gaussianGradient     = "CIGaussianGradient"
        case linearGradient       = "CILinearGradient"
        case radialGradient       = "CIRadialGradient"
        case smoothLinearGradient = "CISmoothLinearGradient"
    }

    enum HalftoneEffect: String {
        case circularScreen = "CICircularScreen"
        case cMYKHalftone   = "CICMYKHalftone"
        case dotScreen      = "CIDotScreen"
        case hatchedScreen  = "CIHatchedScreen"
        case lineScreen     = "CILineScreen"
    }

    enum Reduction: String {
        case areaAverage            = "CIAreaAverage"
        case areaHistogram          = "CIAreaHistogram"
        case rowAverage             = "CIRowAverage"
        case columnAverage          = "CIColumnAverage"
        case histogramDisplayFilter = "CIHistogramDisplayFilter"
        case areaMaximum            = "CIAreaMaximum"
        case areaMinimum            = "CIAreaMinimum"
        case areaMaximumAlpha       = "CIAreaMaximumAlpha"
        case areaMinimumAlpha       = "CIAreaMinimumAlpha"
    }

    enum Sharpen: String {
        case sharpenLuminance = "CISharpenLuminance"
        case unsharpMask      = "CIUnsharpMask"
    }

    enum Stylize: String {
        case blendWithAlphaMask           = "CIBlendWithAlphaMask"
        case blendWithMask                = "CIBlendWithMask"
        case bloom                        = "CIBloom"
        case comicEffect                  = "CIComicEffect"
        case convolution3X3               = "CIConvolution3X3"
        case convolution5X5               = "CIConvolution5X5"
        case convolution7X7               = "CIConvolution7X7"
        case convolution9Horizo​​ntal       = "CIConvolution9Horizo​​ntal"
        case convolution9Vertical         = "CIConvolution9Vertical"
        case crystallize                  = "CICrystallize"
        case depthOfField                 = "CIDepthOfField"
        case edges                        = "CIEdges"
        case edgeWork                     = "CIEdgeWork"
        case gloom                        = "CIGloom"
        case heightFieldFromMask          = "CIHeightFieldFromMask"
        case hexagonalPixellate           = "CIHexagonalPixellate"
        case highlightShadowAdjust        = "CIHighlightShadowAdjust"
        case lineOverlay                  = "CILineOverlay"
        case pixellate                    = "CIPixellate"
        case pointillize                  = "CIPointillize"
        case shadedMaterial               = "CIShadedMaterial"
        case spotColor                    = "CISpotColor"
        case spotLight                    = "CISpotLight"
    }

    enum TileEffect: String {
        case  affineClamp               = "CIAffineClamp"
        case  affineTile                = "CIAffineTile"
        case  eightfoldReflectedTile    = "CIEightfoldReflectedTile"
        case  fourfoldReflectedTile     = "CIFourfoldReflectedTile"
        case  fourfoldRotatedTile       = "CIFourfoldRotatedTile"
        case  fourfoldTranslatedTile    = "CIFourfoldTranslatedTile"
        case  glideReflectedTile        = "CIGlideReflectedTile"
        case  kaleidoscope              = "CIKaleidoscope"
        case  opTile                    = "CIOpTile"
        case  parallelogramTile         = "CIParallelogramTile"
        case  perspectiveTile           = "CIPerspectiveTile"
        case  sixfoldReflectedTile      = "CISixfoldReflectedTile"
        case  sixfoldRotatedTile        = "CISixfoldRotatedTile"
        case  triangleKaleidoscope      = "CITriangleKaleidoscope"
        case  triangleTile              = "CITriangleTile"
        case  twelvefoldReflectedTile   = "CITwelvefoldReflectedTile"
    }

    enum Transition: String {
        case accordionFold           = "CIAccordionFoldTransition"
        case barsSwipe               = "CIBarsSwipeTransition"
        case copyMachine             = "CICopyMachineTransition"
        case disintegrateWithMask    = "CIDisintegrateWithMaskTransition"
        case dissolve                = "CIDissolveTransition"
        case flash                   = "CIFlashTransition"
        case mod                     = "CIModTransition"
        case pageCurl                = "CIPageCurlTransition"
        case pageCurlWithShadow      = "CIPageCurlWithShadowTransition"
        case ripple                  = "CIRippleTransition"
        case swipe                   = "CISwipeTransition"
    }

}
