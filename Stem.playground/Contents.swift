import UIKit
extension CIFilter {
    convenience init(Blur type: Blur) {
        self.init(name: type.rawValue)!
    }
    enum Blur: String {
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case boxBlur = "CIBoxBlur"
        ///Available in OS X v10.5 and later and in iOS 9 and later.
        case discBlur = "CIDiscBlur"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case gaussianBlur = "CIGaussianBlur"
        ///  Available in OS X v10.10 and later.
        case maskedVariableBlur = "CIMaskedVariableBlur"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case medianFilter = "CIMedianFilter"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case motionBlur = "CIMotionBlur"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case noiseReduction = "CINoiseReduction"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case zoomBlur = "CIZoomBlur"
    }
}
extension CIFilter {
    convenience init(ColorAdjustment type: ColorAdjustment) {
        self.init(name: type.rawValue)!
    }
    enum ColorAdjustment: String {
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case colorClamp = "CIColorClamp"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case colorControls = "CIColorControls"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case colorMatrix = "CIColorMatrix"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case colorPolynomial = "CIColorPolynomial"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case exposureAdjust = "CIExposureAdjust"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case gammaAdjust = "CIGammaAdjust"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case hueAdjust = "CIHueAdjust"
        ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
        case linearToSRGBToneCurve = "CILinearToSRGBToneCurve"
        ///  Available in OS X v10.10 and later and in iOS 7.0 and later.
        case sRGBToneCurveToLinear = "CISRGBToneCurveToLinear"
        ///  Available in OS X v10.7 and later and in iOS 5.0 and later.
        case temperatureAndTint = "CITemperatureAndTint"
        ///  Available in OS X v10.7 and later and in iOS 5.0 and later.
        case toneCurve = "CIToneCurve"
        ///  Available in OS X v10.7 and later and in iOS 5.0 and later.
        case vibrance = "CIVibrance"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case whitePointAdjust = "CIWhitePointAdjust"
    }
}
extension CIFilter {
    convenience init(ColorEffect type: ColorEffect) {
        self.init(name: type.rawValue)!
    }
    enum ColorEffect: String {
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case colorCrossPolynomial = "CIColorCrossPolynomial"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorCube = "CIColorCube"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case colorCubeWithColorSpace = "CIColorCubeWithColorSpace"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorInvert = "CIColorInvert"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorMap = "CIColorMap"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorMonochrome = "CIColorMonochrome"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorPosterize = "CIColorPosterize"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case falseColor = "CIFalseColor"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case maskToAlpha = "CIMaskToAlpha"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case maximumComponent = "CIMaximumComponent"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case minimumComponent = "CIMinimumComponent"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectChrome = "CIPhotoEffectChrome"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectFade = "CIPhotoEffectFade"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectInstant = "CIPhotoEffectInstant"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectMono = "CIPhotoEffectMono"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectNoir = "CIPhotoEffectNoir"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectProcess = "CIPhotoEffectProcess"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectTonal = "CIPhotoEffectTonal"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case photoEffectTransfer = "CIPhotoEffectTransfer"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case sepiaTone = "CISepiaTone"
        ///  Available in OS X v10.9 and later and in iOS 5.0 and later.
        case vignette = "CIVignette"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case vignetteEffect = "CIVignetteEffect"
    }
}
extension CIFilter {
    convenience init(CompositeOperation type: CompositeOperation) {
        self.init(name: type.rawValue)!
    }
    enum CompositeOperation: String {
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case additionCompositing = "CIAdditionCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorBlendMode = "CIColorBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorBurnBlendMode = "CIColorBurnBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case colorDodgeBlendMode = "CIColorDodgeBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case darkenBlendMode = "CIDarkenBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case differenceBlendMode = "CIDifferenceBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case divideBlendMode = "CIDivideBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case exclusionBlendMode = "CIExclusionBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case hardLightBlendMode = "CIHardLightBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case hueBlendMode = "CIHueBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case lightenBlendMode = "CILightenBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case linearBurnBlendMode = "CILinearBurnBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case linearDodgeBlendMode = "CILinearDodgeBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case luminosityBlendMode = "CILuminosityBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case maximumCompositing = "CIMaximumCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case minimumCompositing = "CIMinimumCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case multiplyBlendMode = "CIMultiplyBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case multiplyCompositing = "CIMultiplyCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case overlayBlendMode = "CIOverlayBlendMode"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case pinLightBlendMode = "CIPinLightBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case saturationBlendMode = "CISaturationBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case screenBlendMode = "CIScreenBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case softLightBlendMode = "CISoftLightBlendMode"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case sourceAtopCompositing = "CISourceAtopCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case sourceInCompositing = "CISourceInCompositing"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case sourceOutCompositing = "CISourceOutCompositing"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case sourceOverCompositing = "CISourceOverCompositing"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case subtractBlendMode = "CISubtractBlendMode"
    }
}
extension CIFilter {
    convenience init(DistortionEffect type: DistortionEffect) {
        self.init(name: type.rawValue)!
    }
    enum DistortionEffect: String {
        ///  Available in OS X v10.4 and later and in iOS 7.0 and later.
        case bumpDistortion = "CIBumpDistortion"
        ///  Available in OS X v10.5 and later.
        case bumpDistortionLinear = "CIBumpDistortionLinear"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case circleSplashDistortion = "CICircleSplashDistortion"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case circularWrap = "CICircularWrap"
        ///  Available in OS X v10.6 and later and in iOS 9 and later.
        case droste = "CIDroste"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case displacementDistortion = "CIDisplacementDistortion"
        ///  Available in OS X v10.4 and later and in iOS 8.0 and later.
        case glassDistortion = "CIGlassDistortion"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case glassLozenge = "CIGlassLozenge"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case holeDistortion = "CIHoleDistortion"
        ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
        case lightTunnel = "CILightTunnel"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case pinchDistortion = "CIPinchDistortion"
        ///  Available in OS X v10.6 and later and in iOS 9 and later.
        case stretchCrop = "CIStretchCrop"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case torusLensDistortion = "CITorusLensDistortion"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case twirlDistortion = "CITwirlDistortion"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case vortexDistortion = "CIVortexDistortion"
    }
}
extension CIFilter {
    convenience init(Generator type: Generator) {
        self.init(name: type.rawValue)!
    }
    enum Generator: String {
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case aztecCodeGenerator = "CIAztecCodeGenerator"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case checkerboardGenerator = "CICheckerboardGenerator"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case code128BarcodeGenerator = "CICode128BarcodeGenerator"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case constantColorGenerator = "CIConstantColorGenerator"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case lenticularHaloGenerator = "CILenticularHaloGenerator"
        ///  Available in OS X v10.11 and later and in iOS 9 and later.
        case pDF417BarcodeGenerator = "CIPDF417BarcodeGenerator"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case qRCodeGenerator = "CIQRCodeGenerator"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case randomGenerator = "CIRandomGenerator"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case starShineGenerator = "CIStarShineGenerator"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case stripesGenerator = "CIStripesGenerator"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case sunbeamsGenerator = "CISunbeamsGenerator"
    }
}
extension CIFilter {
    convenience init(GeometryAdjustment type: GeometryAdjustment) {
        self.init(name: type.rawValue)!
    }
    enum GeometryAdjustment: String {
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case affineTransform = "CIAffineTransform"
        ///  Available in OS X v10.4 and later and in iOS 5.0 and later.
        case crop = "CICrop"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case lanczosScaleTransform = "CILanczosScaleTransform"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case perspectiveCorrection = "CIPerspectiveCorrection"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case perspectiveTransform = "CIPerspectiveTransform"
        ///  Available in iOS 6.0 and later.
        case perspectiveTransformWithExtent = "CIPerspectiveTransformWithExtent"
        ///  Available in OS X v10.7 and later and in iOS 5.0 and later.
        case straightenFilter = "CIStraightenFilter"
    }
}
extension CIFilter {
    convenience init(Gradient type: Gradient) {
        self.init(name: type.rawValue)!
    }
    enum Gradient: String {
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case gaussianGradient = "CIGaussianGradient"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case linearGradient = "CILinearGradient"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case radialGradient = "CIRadialGradient"
        ///  Available in OS X v10.11 and later and in iOS 7.0 and later.
        case smoothLinearGradient = "CISmoothLinearGradient"
    }
}
extension CIFilter {
    convenience init(HalftoneEffect type: HalftoneEffect) {
        self.init(name: type.rawValue)!
    }
    enum HalftoneEffect: String {
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case circularScreen = "CICircularScreen"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case cMYKHalftone = "CICMYKHalftone"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case dotScreen = "CIDotScreen"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case hatchedScreen = "CIHatchedScreen"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case lineScreen = "CILineScreen"
    }
}
extension CIFilter {
    convenience init(Reduction type: Reduction) {
        self.init(name: type.rawValue)!
    }
    enum Reduction: String {
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case areaAverage = "CIAreaAverage"
        ///  Available in OS X v10.5 and later and in iOS 8.0 and later.
        case areaHistogram = "CIAreaHistogram"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case rowAverage = "CIRowAverage"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case columnAverage = "CIColumnAverage"
        ///  Available in OS X v10.9 and later and in iOS 8.0 and later.
        case histogramDisplayFilter = "CIHistogramDisplayFilter"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case areaMaximum = "CIAreaMaximum"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case areaMinimum = "CIAreaMinimum"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case areaMaximumAlpha = "CIAreaMaximumAlpha"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case areaMinimumAlpha = "CIAreaMinimumAlpha"
    }
}
extension CIFilter {
    convenience init(Sharpen type: Sharpen) {
        self.init(name: type.rawValue)!
    }
    enum Sharpen: String {
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case sharpenLuminance = "CISharpenLuminance"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case unsharpMask = "CIUnsharpMask"
    }
}
extension CIFilter {
    convenience init(Stylize type: Stylize) {
        self.init(name: type.rawValue)!
    }
    enum Stylize: String {
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case blendWithAlphaMask = "CIBlendWithAlphaMask"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case blendWithMask = "CIBlendWithMask"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case bloom = "CIBloom"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case comicEffect = "CIComicEffect"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case convolution3X3 = "CIConvolution3X3"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case convolution5X5 = "CIConvolution5X5"
        ///  Available in OS X v10.9 and later and in iOS 9 and later.
        case convolution7X7 = "CIConvolution7X7"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case convolution9Horizontal = "CIConvolution9Horizontal"
        ///  Available in OS X v10.9 and later and in iOS 7.0 and later.
        case convolution9Vertical = "CIConvolution9Vertical"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case crystallize = "CICrystallize"
        ///  Available in OS X v10.6 and later and in iOS 9 and later.
        case depthOfField = "CIDepthOfField"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case edges = "CIEdges"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case edgeWork = "CIEdgeWork"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case gloom = "CIGloom"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case heightFieldFromMask = "CIHeightFieldFromMask"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case hexagonalPixellate = "CIHexagonalPixellate"
        ///  Available in OS X v10.7 and later and in iOS 5.0 and later.
        case highlightShadowAdjust = "CIHighlightShadowAdjust"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case lineOverlay = "CILineOverlay"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case pixellate = "CIPixellate"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case pointillize = "CIPointillize"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case shadedMaterial = "CIShadedMaterial"
        ///  Available in OS X v10.5 and later and in iOS 9 and later.
        case spotColor = "CISpotColor"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case spotLight = "CISpotLight"
    }
}
extension CIFilter {
    convenience init(TileEffect type: TileEffect) {
        self.init(name: type.rawValue)!
    }
    enum TileEffect: String {
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case affineClamp = "CIAffineClamp"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case affineTile = "CIAffineTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case eightfoldReflectedTile = "CIEightfoldReflectedTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case fourfoldReflectedTile = "CIFourfoldReflectedTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case fourfoldRotatedTile = "CIFourfoldRotatedTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case fourfoldTranslatedTile = "CIFourfoldTranslatedTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case glideReflectedTile = "CIGlideReflectedTile"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case kaleidoscope = "CIKaleidoscope"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case opTile = "CIOpTile"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case parallelogramTile = "CIParallelogramTile"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case perspectiveTile = "CIPerspectiveTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case sixfoldReflectedTile = "CISixfoldReflectedTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case sixfoldRotatedTile = "CISixfoldRotatedTile"
        ///  Available in OS X v10.11 and later and in iOS 6.0 and later.
        case triangleKaleidoscope = "CITriangleKaleidoscope"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case triangleTile = "CITriangleTile"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case twelvefoldReflectedTile = "CITwelvefoldReflectedTile"
    }
}
extension CIFilter {
    convenience init(Transition type: Transition) {
        self.init(name: type.rawValue)!
    }
    enum Transition: String {
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case accordionFoldTransition = "CIAccordionFoldTransition"
        ///  Available in OS X v10.5 and later and in iOS 6.0 and later.
        case barsSwipeTransition = "CIBarsSwipeTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case copyMachineTransition = "CICopyMachineTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case disintegrateWithMaskTransition = "CIDisintegrateWithMaskTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case dissolveTransition = "CIDissolveTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case flashTransition = "CIFlashTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case modTransition = "CIModTransition"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case pageCurlTransition = "CIPageCurlTransition"
        ///  Available in OS X v10.9 and later and in iOS 9 and later.
        case pageCurlWithShadowTransition = "CIPageCurlWithShadowTransition"
        ///  Available in OS X v10.4 and later and in iOS 9 and later.
        case rippleTransition = "CIRippleTransition"
        ///  Available in OS X v10.4 and later and in iOS 6.0 and later.
        case swipeTransition = "CISwipeTransition"
    }
}
