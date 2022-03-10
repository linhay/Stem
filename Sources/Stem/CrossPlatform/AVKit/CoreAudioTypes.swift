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

#if canImport(CoreAudioTypes)
import CoreAudioTypes

public enum STAudioFormat: UInt32, Equatable, CaseIterable {
    case linearPCM
    case ac3
    case _60958AC3
    case appleIMA4
    case mpeg4AAC
    case mpeg4CELP
    case mpeg4HVXC
    case mpeg4TwinVQ
    case MACE3
    case MACE6
    case ULaw
    case ALaw
    case QDesign
    case QDesign2
    case QUALCOMM
    case mpegLayer1
    case mpegLayer2
    case mpegLayer3
    case TimeCode
    case MIDIStream
    case ParameterValueStream
    case AppleLossless
    case mpeg4AAC_HE
    case mpeg4AAC_LD
    case mpeg4AAC_ELD
    case mpeg4AAC_ELD_SBR
    case mpeg4AAC_ELD_V2
    case mpeg4AAC_HE_V2
    case mpeg4AAC_Spatial
    case mpegD_USAC
    case AMR
    case AMR_WB
    case Audible
    case iLBC
    case DVIIntelIMA
    case MicrosoftGSM
    case AES3
    case EnhancedAC3
    case FLAC
    case Opus
    
    public var rawValue: UInt32 {
        switch self {
        case .linearPCM: return kAudioFormatLinearPCM
        case .ac3: return kAudioFormatAC3
        case ._60958AC3: return kAudioFormat60958AC3
        case .appleIMA4: return kAudioFormatAppleIMA4
        case .mpeg4AAC: return kAudioFormatMPEG4AAC
        case .mpeg4CELP: return kAudioFormatMPEG4CELP
        case .mpeg4HVXC: return kAudioFormatMPEG4HVXC
        case .mpeg4TwinVQ: return kAudioFormatMPEG4TwinVQ
        case .MACE3: return kAudioFormatMACE3
        case .MACE6: return kAudioFormatMACE6
        case .ULaw: return kAudioFormatULaw
        case .ALaw: return kAudioFormatALaw
        case .QDesign: return kAudioFormatQDesign
        case .QDesign2: return kAudioFormatQDesign2
        case .QUALCOMM: return kAudioFormatQUALCOMM
        case .mpegLayer1: return kAudioFormatMPEGLayer1
        case .mpegLayer2: return kAudioFormatMPEGLayer2
        case .mpegLayer3: return kAudioFormatMPEGLayer3
        case .TimeCode: return kAudioFormatTimeCode
        case .MIDIStream: return kAudioFormatMIDIStream
        case .ParameterValueStream: return kAudioFormatParameterValueStream
        case .AppleLossless: return kAudioFormatAppleLossless
        case .mpeg4AAC_HE: return kAudioFormatMPEG4AAC_HE
        case .mpeg4AAC_LD: return kAudioFormatMPEG4AAC_LD
        case .mpeg4AAC_ELD: return kAudioFormatMPEG4AAC_ELD
        case .mpeg4AAC_ELD_SBR: return kAudioFormatMPEG4AAC_ELD_SBR
        case .mpeg4AAC_ELD_V2: return kAudioFormatMPEG4AAC_ELD_V2
        case .mpeg4AAC_HE_V2: return kAudioFormatMPEG4AAC_HE_V2
        case .mpeg4AAC_Spatial: return kAudioFormatMPEG4AAC_Spatial
        case .mpegD_USAC: return kAudioFormatMPEGD_USAC
        case .AMR: return kAudioFormatAMR
        case .AMR_WB: return kAudioFormatAMR_WB
        case .Audible: return kAudioFormatAudible
        case .iLBC: return kAudioFormatiLBC
        case .DVIIntelIMA: return kAudioFormatDVIIntelIMA
        case .MicrosoftGSM: return kAudioFormatMicrosoftGSM
        case .AES3: return kAudioFormatAES3
        case .EnhancedAC3: return kAudioFormatEnhancedAC3
        case .FLAC: return kAudioFormatFLAC
        case .Opus: return kAudioFormatOpus
        }
    }
    
    var name: String {
        switch self {
        case .linearPCM: return "lpcm"
        case .ac3: return "ac-3"
        case ._60958AC3: return "cac3"
        case .appleIMA4: return "ima4"
        case .mpeg4AAC: return "aac" // 'aac '
        case .mpeg4CELP: return "celp"
        case .mpeg4HVXC: return "hvxc"
        case .mpeg4TwinVQ: return "twvq"
        case .MACE3: return "MAC3"
        case .MACE6: return "MAC6"
        case .ULaw: return "ulaw"
        case .ALaw: return "alaw"
        case .QDesign: return "QDMC"
        case .QDesign2: return "QDM2"
        case .QUALCOMM: return "Qclp"
        case .mpegLayer1: return ".mp1"
        case .mpegLayer2: return ".mp2"
        case .mpegLayer3: return ".mp3"
        case .TimeCode: return "time"
        case .MIDIStream: return "midi"
        case .ParameterValueStream: return "apvs"
        case .AppleLossless: return "alac"
        case .mpeg4AAC_HE: return "aach"
        case .mpeg4AAC_LD: return "aacl"
        case .mpeg4AAC_ELD: return "aace"
        case .mpeg4AAC_ELD_SBR: return "aacf"
        case .mpeg4AAC_ELD_V2: return "aacg"
        case .mpeg4AAC_HE_V2: return "aacp"
        case .mpeg4AAC_Spatial: return "aacs"
        case .mpegD_USAC: return "usac"
        case .AMR: return "samr"
        case .AMR_WB: return "sawb"
        case .Audible: return "AUDB"
        case .iLBC: return "ilbc"
        case .DVIIntelIMA: return "DVIIntelIMA"
        case .MicrosoftGSM: return "MicrosoftGSM"
        case .AES3: return "aes3"
        case .EnhancedAC3: return "ec-3"
        case .FLAC: return "flac"
        case .Opus: return "opus"
        }
    }
    
}

#endif
