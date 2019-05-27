//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Stem

//class MyViewController : UIViewController {
//    override func loadView() {
//
//        var image = UIImage(color: UIColor.red,
//                            size: CGSize(width: 50,
//                                         height: 50))
//        image = image.st.blur(value: 4) ?? image
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .center
//        self.view = imageView
//    }
//}
//// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = MyViewController()


let str = """
enum CICategoryBlur: String {
 CIBoxBlur
 CIDiscBlur
 CIGaussianBlur
 CIMaskedVariableBlur
 CIMedianFilter
 CIMotionBlur
 CINoiseReduction
}

enum CICategoryColorAdjustment: String {
 CIColorClamp
 CIColorControls
 CIColorMatrix
 CIColorPolynomial
 CIExposureAdjust
 CIGammaAdjust
 CIHueAdjust
 CILinearToSRGBToneCurve
 CISRGBToneCurveToLinear
 CITemperatureAndTint
 CIToneCurve
 CIVibrance
 CIWhitePointAdjust
}

enum CICategoryColorEffect: String {
 CIColorCrossPolynomial
 CIColorCube
 CIColorCubeWithColorSpace
 CIColorInvert
 CIColorMap
 CIColorMonochrome
 CIColorPosterize
 CIFalseColor
 CIMaskToAlpha
 CIMaximumComponent
 CIMinimumComponent
 CIPhotoEffectChrome
 CIPhotoEffectFade
 CIPhotoEffectInstant
 CIPhotoEffectMono
 CIPhotoEffectNoir
 CIPhotoEffectProcess
 CIPhotoEffectTonal
 CIPhotoEffectTransfer
 CISepiaTone
 CIVignette
 CIVignetteEffect
}

enum CICategoryCompositeOperation: String {
 CIAdditionCompositing
 CIColorBlendMode
 CIColorBurnBlendMode
 CIColorDodgeBlendMode
 CIDarkenBlendMode
 CIDifferenceBlendMode
 CIDivideBlendMode
 CIExclusionBlendMode
 CIHardLightBlendMode
 CIHueBlendMode
 CILightenBlendMode
 CILinearBurnBlendMode
 CILinearDodgeBlendMode
 CILuminosityBlendMode
 CIMaximumCompositing
 CIMinimumCompositing
 CIMultiplyBlendMode
 CIMultiplyCompositing
 CIOverlayBlendMode
 CIPinLightBlendMode
 CISaturationBlendMode
 CIScreenBlendMode
 CISoftLightBlendMode
 CISourceAtopCompositing
 CISourceInCompositing
 CISourceOutCompositing
 CISourceOverCompositing
 CISubtractBlendMode
}

enum CICategoryDistortionEffect: String {
 CIBumpDistortion
 CIBumpDistortionLinear
 CICircleSplashDistortion
 CICircularWrap
 CIDroste
 CIDisplacementDistortion
 CIGlassDistortion
 CIGlassLozenge
 CIHoleDistortion
 CILightTunnel
 CIPinchDistortion
 CIStretchCrop
 CITorusLensDistortion
 CITwirlDistortion
 CIVortexDistortion
}

enum CICategoryGenerator: String {
 CIAztecCodeGenerator
 CICheckerboardGenerator
 CICodest8CarcodeGenerator
 CIConstantColorGenerator
 CILenticularHaloGenerator
 CIPDF417BarcodeGenerator
 CIQRCodeGenerator
 CIRandomGenerator
 CIStarShineGenerator
 CIStripesGenerator
 CISunbeamsGenerator
}

enum CICategoryGeometryAdjustment: String {
 CIAffineTransform
 CICrop
 CILanczosScaleTransform
 CIPerspectiveCorrection
 CIPerspectiveTransform
 CIPerspectiveTransformWithExtent
 CIStraightenFilter
}

enum CICategoryGradient: String {
 CIGaussianGradient
 CILinearGradient
 CIRadialGradient
 CISmoothLinearGradient
}
enum CICategoryHalftoneEffect: String {
 CICircularScreen
 CICMYKHalftone
 CIDotScreen
 CIHatchedScreen
 CILineScreen
}

enum CICategoryReduction: String {
 CIAreaAverage
 CIAreaHistogram
 CIRowAverage
 CIColumnAverage
 CIHistogramDisplayFilter
 CIAreaMaximum
 CIAreaMinimum
 CIAreaMaximumAlpha
 CIAreaMinimumAlpha
}

enum CICategorySharpen: String {
 CISharpenLuminance
 CIUnsharpMask
}

enum CICategoryStylize: String {
 CIBlendWithAlphaMask
 CIBlendWithMask
 CIBloom
 CIComicEffect
 CIConvolution3X3
 CIConvolution5X5
 CIConvolution7X7
 CIConvolution9Horizo​​ntal
 CIConvolution9Vertical
 CICrystallize
 CIDepthOfField
 CIEdges
 CIEdgeWork
 CIGloom
 CIHeightFieldFromMask
 CIHexagonalPixellate
 CIHighlightShadowAdjust
 CILineOverlay
 CIPixellate
 CIPointillize
 CIShadedMaterial
 CISpotColor
 CISpotLight
}
"""

let lines = str.components(separatedBy: "\n").map { (item) -> String in
    if item.contains("enum") || item.contains("=") || item.contains("}") { return item }
    if item.isEmpty { return item }
    var item = item
    item = item.replacingOccurrences(of: " ", with: "")
    var caseName = item.replacingOccurrences(of: "CI", with: "")
    let index = String.Index(utf16Offset: 0, in: caseName)
    caseName = (caseName.first?.lowercased().description ?? "") + caseName.dropFirst().description

    return "   case " + caseName + " = " + "\"\(item)\""
}.joined(separator: "\n")

print(lines)
