// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreImage

extension CIFilter {
    convenience init(generator type: Generator) {
        self.init(name: type.rawValue)!
    }
    
    public enum Generator: String {
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case aztecCodeGenerator = "CIAztecCodeGenerator"
        case checkerboardGenerator = "CICheckerboardGenerator"
        ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
        case code128BarcodeGenerator = "CICode128BarcodeGenerator"
        case constantColorGenerator = "CIConstantColorGenerator"
        ///   and later and in iOS 9 and later.
        case lenticularHaloGenerator = "CILenticularHaloGenerator"
        ///  Available in OS X v10.11 and later and in iOS 9 and later.
        case pDF417BarcodeGenerator = "CIPDF417BarcodeGenerator"
        case qRCodeGenerator = "CIQRCodeGenerator"
        case randomGenerator = "CIRandomGenerator"
        case starShineGenerator = "CIStarShineGenerator"
        case stripesGenerator = "CIStripesGenerator"
        ///   and later and in iOS 9 and later.
        case sunbeamsGenerator = "CISunbeamsGenerator"
    }
}

public extension CIFilter.Generator {
    /**
     Discussion
     Generates an output image representing the input data according to the ISO/IEC 24778:2008 standard. The width and height of each module (square dot) of the code in the output image is one pixel. To create an Aztec code from a string or URL, convert it to an NSData object using the NSISOLatin1StringEncoding string encoding. The output image also includes two pixels of padding on each side (for example, a 15 x 15 code creates a 19 x 19 image).
     */
    ///Available in OS X v10.10 and later and in iOS 8.0 and later.
    struct AztecCode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .aztecCodeGenerator)
        
        ///The data to be encoded as an Aztec code. An NSData object whose display name is Message.
        @CIFilterValueBox
        var message: Data?
        
        ///The percentage of redundancy to add to the message data in the barcode encoding. A higher correction level allows a barcode to be correctly read even when partially damaged.
        ///An NSNumber object whose display name is CorrectionLevel.
        ///Default value: 23.00 Minimum: 5.00 Maximum: 95.00 Slider minimum: 5.00 Slider maximum: 95.00 Identity: 0.00
        @CIFilterValueBox
        var correctionLevel: NSNumber
        
        ///The number of concentric squares (with a width of two pixels each) encoding the barcode data. When this parameter is set to zero, Core Image automatically determines the appropriate number of layers to encode the message at the specified correction level.
        ///An NSNumber object whose display name is Layers.
        ///Default value: 0.00 Minimum: 1.00 Maximum: 32.00 Slider minimum: 1.00 Slider maximum: 32.00 Identity: 0.00
        @CIFilterValueBox
        var layers: NSNumber
        
        ///A Boolean value that determines whether to use the compact or full-size Aztec barcode format. The compact format can store up to 44 bytes of message data (including data added for correction) in up to 4 layers, producing a barcode image sized between 15 x 15 and 27 x 27 pixels. The full-size format can store up to 1914 bytes of message data (including correction) in up to 32 layers, producing a barcode image sized no larger than 151 x 151 pixels.
        ///An NSNumber object whose display name is CompactStyle.
        ///Default value: 0.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox
        var compactStyle: NSNumber
        
        init() {
            _message.cofig(filter: filter, name: "inputMessage", default: nil)
            _correctionLevel.cofig(filter: filter, name: "inputCorrectionLevel", default: 23.00)
            _layers.cofig(filter: filter, name: "inputLayers", default: 0)
            _compactStyle.cofig(filter: filter, name: "inputCompactStyle", default: 0)
        }
    }
    /**
     Discussion
     You can specify the checkerboard size and colors, and the sharpness of the pattern.
     */
    struct Checkerboard: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .checkerboardGenerator)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox
        var center: CIVector
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox
        var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox
        var color1: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 80.00
        @CIFilterValueBox
        var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 1.00
        @CIFilterValueBox
        var sharpness: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150] "))
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
            _width.cofig(filter: filter, name: "inputWidth", default: 80.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 1.00)
        }
    }
    /**
     Discussion
     Generates an output image representing the input data according to the ISO/IEC 15417:2007 standard. The width of each module (vertical line) of the barcode in the output image is one pixel. The height of the barcode is 32 pixels. To create a barcode from a string or URL, convert it to an NSData object using the NSASCIIStringEncoding string encoding.
     */
    ///  Available in OS X v10.10 and later and in iOS 8.0 and later.
    struct Code128Barcode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .code128BarcodeGenerator)
        
        ///  The data to be encoded as a Code 128 barcode. Must not contain non-ASCII characters. An NSData object whose display name is Message.
        @CIFilterValueBox
        public var message: Data?
        
        ///  The number of pixels of added white space on each side of the barcode. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is QuietSpace.
        ///  Default value: 7.00 Minimum: 0.00 Maximum: 20.00 Slider minimum: 0.00 Slider maximum: 20.00 Identity: 0.00
        @CIFilterValueBox
        public var quietSpace: NSNumber
        
        public init() {
            _message.cofig(filter: filter, name: "inputMessage", default: nil)
            _quietSpace.cofig(filter: filter, name: "inputQuietSpace", default: 7.00)
        }
    }
    /**
     Discussion
     You typically use the output of this filter as the input to another filter.
     */
    struct ConstantColor: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .constantColorGenerator)
        
        ///  A CIColor object whose display name is Color.
        @CIFilterValueBox
        public var color: CIColor?
        
        init() {
            _color.cofig(filter: filter, name: "inputColor", default: nil)
        }
    }
    /**
     Discussion
     This filter is typically applied to another image to simulate lens flares and similar effects.
     */
    ///   and later and in iOS 9 and later.
    struct LenticularHalo: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .lenticularHaloGenerator)
        
        ///  The center of the lens flare. A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox
        var center: CIVector
        
        ///  Controls the proportion of red, green, and blue halos. A CIColor object whose display name is Color.
        @CIFilterValueBox
        var color: CIColor?
        
        ///  Controls the size of the lens flare. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Halo Radius.
        ///  Default value: 70.00
        @CIFilterValueBox
        var haloRadius: NSNumber
        
        ///  Controls the width of the lens flare, that is, the distance between the inner flare and the outer flare. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Halo Width.
        ///  Default value: 87.00
        @CIFilterValueBox
        var haloWidth: NSNumber
        
        ///  Controls how much the red, green, and blue halos overlap. A value of 0 means no overlap (a lot of separation).  A value of 1 means full overlap (white halos). An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Halo Overlap.
        ///  Default value: 0.77
        @CIFilterValueBox
        var haloOverlap: NSNumber
        
        ///  Controls the brightness of the rainbow-colored halo area. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Strength.
        ///  Default value: 0.50
        @CIFilterValueBox
        var striationStrength: NSNumber
        
        ///  Controls the contrast of the rainbow-colored halo area. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Contrast.
        ///  Default value: 1.00
        @CIFilterValueBox
        var striationContrast: NSNumber
        
        ///  Adds a randomness to the lens flare; it causes the flare to "sparkle" as it changes through various time values. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox
        var time: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _haloRadius.cofig(filter: filter, name: "inputHaloRadius", default: 70.00)
            _haloWidth.cofig(filter: filter, name: "inputHaloWidth", default: 87.00)
            _haloOverlap.cofig(filter: filter, name: "inputHaloOverlap", default: 0.77)
            _striationStrength.cofig(filter: filter, name: "inputStriationStrength", default: 0.50)
            _striationContrast.cofig(filter: filter, name: "inputStriationContrast", default: 1.00 )
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
        }
    }
    /**
     Discussion
     Generates an output image representing the input data according to the ISO 15438 standard. PDF417 codes are commonly used in postage, package tracking, personal identification documents, and coffeeshop membership cards. The width and height of each module (square dot) of the code in the output image is one point. To create a PDF417 code from a string or URL, convert it to an NSData object using the NSISOLatin1StringEncoding string encoding.
     */
    ///  Available in OS X v10.11 and later and in iOS 9 and later.
    struct PDF417Barcode: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .pDF417BarcodeGenerator)
        
        ///  The data to be encoded as a barcode. An NSData object whose display name is Message.
        @CIFilterValueBox
        var message: Data?
        
        ///  The minimum width of the barcode’s data area, in pixels. An NSNumber object whose display name is MinWidth.
        ///  Default value: 0.00 Minimum: 56.00 Maximum: 583.00 Slider minimum: 56.00 Slider maximum: 583.00 Identity: 0.00
        @CIFilterValueBox
        var minWidth: NSNumber
        
        ///  The maximum width of the barcode’s data area, in pixels. An NSNumber object whose display name is MaxWidth.
        ///  Default value: 0.00 Minimum: 56.00 Maximum: 583.00 Slider minimum: 56.00 Slider maximum: 583.00 Identity: 0.00
        @CIFilterValueBox
        var maxWidth: NSNumber
        
        ///  The minimum height of the barcode’s data area, in pixels. An NSNumber object whose display name is MinHeight.
        ///  Default value: 0.00 Minimum: 13.00 Maximum: 283.00 Slider minimum: 13.00 Slider maximum: 283.00 Identity: 0.00
        @CIFilterValueBox
        var minHeight: NSNumber
        
        ///  The maximum height of the barcode’s data area, in pixels. An NSNumber object whose display name is MaxHeight.
        ///  Default value: 0.00 Minimum: 13.00 Maximum: 283.00 Slider minimum: 13.00 Slider maximum: 283.00 Identity: 0.00
        @CIFilterValueBox
        var maxHeight: NSNumber
        
        ///  The number of data columns in the generated code. If zero, the generator uses a number of columns based on the width, height, and aspect ratio. An NSNumber object whose display name is DataColumns.
        ///  Default value: 0.00 Minimum: 1.00 Maximum: 30.00 Slider minimum: 1.00 Slider maximum: 30.00 Identity: 0.00
        @CIFilterValueBox
        var dataColumns: NSNumber
        
        ///  The number of data rows in the generated code. If zero, the generator uses a number of rows based on the width, height, and aspect ratio. An NSNumber object whose display name is Rows.
        ///  Default value: 0.00 Minimum: 3.00 Maximum: 90.00 Slider minimum: 3.00 Slider maximum: 90.00 Identity: 0.00
        @CIFilterValueBox
        var rows: NSNumber
        
        ///  The preferred ratio of width over height for the generated barcode. The generator approximates this with an actual aspect ratio based on the data and other parameters you specify. An NSNumber object whose display name is PreferredAspectRatio.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 9223372036854775808.00 Slider minimum: 0.00 Slider maximum: 9223372036854775808.00 Identity: 0.00
        @CIFilterValueBox
        var preferredAspectRatio: NSNumber
        
        ///  An option that determines which method the generator uses to compress data.
        ///  Automatic. The generator automatically chooses a compression method. This option is the default.
        ///  Numeric. Valid only when the message is an ASCII-encoded string of digits, achieving optimal compression for that type of data.
        ///  Text. Valid only when the message is all ASCII-encoded alphanumeric and punctuation characters, achieving optimal compression for that type of data.
        ///  Byte. Valid for any data, but least compact.
        ///  An NSNumber object whose display name is CompactionMode.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 3.00 Slider minimum: 0.00 Slider maximum: 3.00 Identity: 0.00
        @CIFilterValueBox
        var compactionMode: NSNumber?
        
        ///  A Boolean value that determines whether to omit redundant elements to make the generated barcode more compact. An NSNumber object whose display name is CompactStyle.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 1.00 Slider minimum: 0.00 Slider maximum: 1.00 Identity: 0.00
        @CIFilterValueBox
        var compactStyle: NSNumber
        
        ///  An integer between 0 and 8, inclusive, that determines the amount of redundancy to include in the barcode’s data to prevent errors when the barcode is read. If unspecified, the generator chooses a correction level based on the size of the message data. An NSNumber object whose display name is CorrectionLevel.
        ///  Default value: 0.00 Minimum: 0.00 Maximum: 8.00 Slider minimum: 0.00 Slider maximum: 8.00 Identity: 0.00
        @CIFilterValueBox
        var correctionLevel: NSNumber
        
        ///  A Boolean value that determines whether to include information about the compaction mode in the barcode even when such information is redundant. (If a PDF417 barcode does not contain compaction mode information, a reader assumes text-based compaction. Some barcodes include this information even when using text-based compaction.)
        ///  An NSNumber object whose display name is AlwaysSpecifyCompaction.
        ///  Default value: 0.00 Minimum: -9223372036854775808.00 Maximum: 9223372036854775808.00 Slider minimum: -9223372036854775808.00 Slider maximum: 9223372036854775808.00 Identity: 0.00
        @CIFilterValueBox
        var alwaysSpecifyCompaction: NSNumber
        
        init() {
            _message.cofig(filter: filter, name: "inputMessage", default: nil)
            _minWidth.cofig(filter: filter, name: "inputMinWidth", default: 0.00)
            _maxWidth.cofig(filter: filter, name: "inputMaxWidth", default: 0.00)
            _minHeight.cofig(filter: filter, name: "inputMinHeight", default: 0.00)
            _maxHeight.cofig(filter: filter, name: "inputMaxHeight", default: 0.00)
            _dataColumns.cofig(filter: filter, name: "inputDataColumns", default: 0.00)
            _rows.cofig(filter: filter, name: "inputRows", default: 0.00)
            _preferredAspectRatio.cofig(filter: filter, name: "inputPreferredAspectRatio", default: 0.00)
            _compactionMode.cofig(filter: filter, name: "inputCompactionMode", default: nil)
            _compactStyle.cofig(filter: filter, name: "inputCompactStyle", default: 0.00)
            _correctionLevel.cofig(filter: filter, name: "inputCorrectionLevel", default: 0.00)
            _alwaysSpecifyCompaction.cofig(filter: filter, name: "inputAlwaysSpecifyCompaction", default: 0)
        }
    }
    /**
     Discussion
     Generates an output image representing the input data according to the ISO/IEC 18004:2006 standard. The width and height of each module (square dot) of the code in the output image is one point. To create a QR code from a string or URL, convert it to an NSData object using the NSISOLatin1StringEncoding string encoding.
     The inputCorrectionLevel parameter controls the amount of additional data encoded in the output image to provide error correction. Higher levels of error correction result in larger output images but allow larger areas of the code to be damaged or obscured without. There are four possible correction modes (with corresponding error resilience levels):
     L: 7%
     M: 15%
     Q: 25%
     H: 30%
     */
    class QRCode: CIFilterContainerProtocol {
        public let filter: CIFilter = CIFilter(generator: .qRCodeGenerator)
        
        /// 纠错等级
        public enum CorrectionLevel: String, CaseIterable {
            /// 7%
            case l = "L"
            /// 15%
            case m = "M"
            /// 25%
            case q = "Q"
            /// 30%
            case h = "H"
            
            public var level: Double {
                switch self {
                case .l: return 0.07
                case .m: return 0.15
                case .q: return 0.25
                case .h: return 0.30
                }
            }
            
            init(level: Double) {
                if  level < CorrectionLevel.m.level {
                    self = .l
                    return
                }
                if level >= CorrectionLevel.m.level || level < CorrectionLevel.q.level {
                    self = .m
                    return
                }
                if level >= CorrectionLevel.q.level || level < CorrectionLevel.h.level {
                    self = .q
                    return
                }
                if level >= CorrectionLevel.h.level {
                    self = .h
                    return
                }
                self = .m
            }
            
        }
        
        /// 纠错等级
        public var level: CorrectionLevel {
            get { return CorrectionLevel(rawValue: correctionLevel)  ?? .m }
            set { correctionLevel = newValue.rawValue }
        }
        
        ///  The data to be encoded as a QR code. An NSData object whose display name is Message.
        @CIFilterValueBox
        var message: Data?
        
        ///  A single letter specifying the error correction format. An NSString object whose display name is CorrectionLevel.
        ///  Default value: M
        @CIFilterValueBox private var correctionLevel: String
        
        init() {
            _message.cofig(filter: filter, name: "inputMessage", default: nil)
            _correctionLevel.cofig(filter: filter, name: "inputCorrectionLevel", default: "M")
        }
    }
    
    struct Random: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .randomGenerator)
    }
    
    /**
     Discussion
     The output image is typically used as input to another filter.
     */
    struct StarShine: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .starShineGenerator)
        
        ///  The center of the flare. A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox
        var center: CIVector
        
        ///  The color of the flare. A CIColor object whose display name is Color.
        @CIFilterValueBox
        var color: CIColor?
        
        ///  Controls the size of the flare. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Radius.
        ///  Default value: 50.00
        @CIFilterValueBox
        var radius: NSNumber
        
        ///  Controls the ratio of the cross flare size relative to the round central flare. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Cross Scale.
        ///  Default value: 15.00
        @CIFilterValueBox
        var crossScale: NSNumber
        
        ///  Controls the angle of the flare. An NSNumber object whose attribute type is CIAttributeTypeAngle and whose display name is Cross Angle.
        ///  Default value: 0.60
        @CIFilterValueBox
        var crossAngle: NSNumber
        
        ///  Controls the thickness of the cross flare. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Cross Opacity.
        ///  Default value: -2.00
        @CIFilterValueBox
        var crossOpacity: NSNumber
        
        ///  Has the same overall effect as the inputCrossOpacity parameter. An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Cross Width.
        ///  Default value: 2.50
        @CIFilterValueBox
        var crossWidth: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Epsilon.
        ///  Default value: -2.00
        @CIFilterValueBox
        var epsilon: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _radius.cofig(filter: filter, name: "inputRadius", default: 50.00)
            _crossScale.cofig(filter: filter, name: "inputCrossScale", default: 15.00)
            _crossAngle.cofig(filter: filter, name: "inputCrossAngle", default: 0.60)
            _crossOpacity.cofig(filter: filter, name: "inputCrossOpacity", default: -2.00)
            _crossWidth.cofig(filter: filter, name: "inputCrossWidth", default: 2.50)
            _epsilon.cofig(filter: filter, name: "inputEpsilon", default: -2.00)
        }
    }
    /**
     Discussion
     You can control the color of the stripes, the spacing, and the contrast.
     */
    struct Stripes: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .stripesGenerator)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox
        var center: CIVector
        
        ///  A CIColor object whose display name is Color 1.
        @CIFilterValueBox
        var color0: CIColor?
        
        ///  A CIColor object whose display name is Color 2.
        @CIFilterValueBox
        var color1: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Width.
        ///  Default value: 80.00
        @CIFilterValueBox
        var width: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Sharpness.
        ///  Default value: 1.00
        @CIFilterValueBox
        var sharpness: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _color0.cofig(filter: filter, name: "inputColor0", default: nil)
            _color1.cofig(filter: filter, name: "inputColor1", default: nil)
            _width.cofig(filter: filter, name: "inputWidth", default: 80.00)
            _sharpness.cofig(filter: filter, name: "inputSharpness", default: 1.00)
        }
    }
    /**
     Discussion
     You typically use the output of the sunbeams filter as input to a composite filter.
     */
    ///   and later and in iOS 9 and later.
    struct Sunbeams: CIFilterContainerProtocol {
        public var filter: CIFilter = CIFilter(generator: .sunbeamsGenerator)
        
        ///  A CIVector object whose attribute type is CIAttributeTypePosition and whose display name is Center.
        ///  Default value: [150 150]
        @CIFilterValueBox
        var center: CIVector
        
        ///  A CIColor object whose display name is Color.
        @CIFilterValueBox
        var color: CIColor?
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeDistance and whose display name is Sun Radius.
        ///  Default value: 40.00
        @CIFilterValueBox
        var sunRadius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Maximum Striation Radius.
        ///  Default value: 2.58
        @CIFilterValueBox
        var maxStriationRadius: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Strength.
        ///  Default value: 0.50
        @CIFilterValueBox
        var striationStrength: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Striation Contrast.
        ///  Default value: 1.38
        @CIFilterValueBox
        var striationContrast: NSNumber
        
        ///  An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is Time.
        ///  Default value: 0.00
        @CIFilterValueBox
        var time: NSNumber
        
        init() {
            _center.cofig(filter: filter, name: "inputCenter", default: .init(string: "[150 150]"))
            _color.cofig(filter: filter, name: "inputColor", default: nil)
            _sunRadius.cofig(filter: filter, name: "inputSunRadius", default: 40.00)
            _maxStriationRadius.cofig(filter: filter, name: "inputMaxStriationRadius", default: 2.58)
            _striationStrength.cofig(filter: filter, name: "inputStriationStrength", default: 0.50)
            _striationContrast.cofig(filter: filter, name: "inputStriationContrast", default: 1.38)
            _time.cofig(filter: filter, name: "inputTime", default: 0.00)
        }
    }
}
