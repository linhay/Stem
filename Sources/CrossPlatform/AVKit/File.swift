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

#if canImport(AVFoundation)
import AVFoundation

open class STAudioRecorder: AVAudioRecorder {
    
    public struct Format {
        
        let rawValue: STAudioFormat
        
        init(_ rawValue: STAudioFormat) {
            self.rawValue = rawValue
        }
        
        public let all: [Format] = [.linearPCM,
                                    .appleIMA4,
                                    .mpeg4AAC,
                                    .uLaw, .aLaw,
                                    .appleLossless]
        
        public static let linearPCM = Format(.linearPCM)
        public static let appleIMA4 = Format(.appleIMA4)
        public static let mpeg4AAC = Format(.mpeg4AAC)
        public static let uLaw = Format(.ULaw)
        public static let aLaw = Format(.ALaw)
        public static let appleLossless = Format(.AppleLossless)
    }
    
    public enum LinearPCMSettings {
        
        public enum BitDepth: Int {
            case _8  = 8
            case _16 = 16
            case _24 = 24
            case _32 = 32
        }
        
        /// 比特率: 8、16、24 或 32
        case bitDepth(BitDepth)
        /// 音频格式是大端 ( true) 还是小端 ( false)
        case isBigEndian(Bool)
        /// 音频格式是浮点 ( true) 还是定点 ( false)
        case isFloatKey(Bool)
        case isNonInterleaved(Bool)

        public var item: [String: Any] {
            switch self {
            case .bitDepth(let value):
                return [AVLinearPCMBitDepthKey: value.rawValue]
            case .isBigEndian(let value):
                return [AVLinearPCMIsBigEndianKey: value]
            case .isFloatKey(let value):
                return [AVLinearPCMIsFloatKey: value]
            case .isNonInterleaved(let value):
                return [AVLinearPCMIsNonInterleaved: value]
            }
        }
        
    }
    
    // https://developer.apple.com/documentation/avfaudio/avaudiorecorder/1388386-initwithurl
    public enum Settings {
        case format(Format)
        case sampleRate(Double)
        case channels(Int)
        /// 表示线性PCM音频格式的比特深度: 8、16、24或32
        case linearPCM([LinearPCMSettings])
        case audioQuality(AVAudioQuality)
        /// 比特采样率
        case bitRate(Int)
        
        public var item: [String: Any] {
            switch self {
            case .bitRate(let value):
                return [AVEncoderBitRateKey: value]
            case .audioQuality(let value):
                return [AVEncoderAudioQualityKey: value.rawValue]
            case .linearPCM(let settings):
                return settings.reduce([String: Any]()) { $0.merging($1.item, uniquingKeysWith: { $1 }) }
            case .format(let value):
                return [AVFormatIDKey: value.rawValue.rawValue]
            case .sampleRate(let value):
                return [AVSampleRateKey: value]
            case .channels(let value):
                return [AVNumberOfChannelsKey: value]
            }
        }
        
    }
    
    public convenience init(URL url: URL, settings: [Settings]) throws {
        try self.init(url: url, settings: settings.reduce([String: Any](), { $0.merging($1.item, uniquingKeysWith: { $1 }) }))
    }
    
}

#endif
