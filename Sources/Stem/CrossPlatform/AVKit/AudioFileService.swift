//
//  File.swift
//  
//
//  Created by linhey on 2023/1/13.
//

import Foundation
import AudioToolbox

/// http://msching.github.io/blog/2014/07/19/audio-in-ios-4/
public class STAudioFileService {
    
    let fd: AudioFileID
    
    public init(url: URL,
                inPermissions: AudioFilePermissions = .readPermission,
                type: AudioFileTypeID = 0) throws {
        var fd: AudioFileID?
        let status = AudioFileOpenURL(url as CFURL, inPermissions, type, &fd)
        guard status == noErr, let fd = fd else {
            throw StemError("error")
        }
        self.fd = fd
    }
    
    deinit {
        close()
    }
    
    public struct Property<Value> {
        public static var dataOffset: Property<Int>                         { .init(id: kAudioFilePropertyDataOffset) }
        public static var packetRangeByteCountUpperBound: Property<Int>     { .init(id: kAudioFilePropertyPacketRangeByteCountUpperBound) }
        public static var id3TagOffset: Property<Int>                       { .init(id: kAudioFilePropertyID3TagOffset) }
        public static var packetToRollDistance: Property<Int>               { .init(id: kAudioFilePropertyPacketToRollDistance) }
        public static var packetSizeUpperBound: Property<Int>               { .init(id: kAudioFilePropertyPacketSizeUpperBound) }
        public static var estimatedDuration: Property<Double>               { .init(id: kAudioFilePropertyEstimatedDuration) }
        public static var bitRate: Property<Int>                            { .init(id: kAudioFilePropertyBitRate) }
        public static var isOptimized: Property<Bool>                       { .init(id: kAudioFilePropertyIsOptimized) }
//        public static var bitDepth: Property<Int>                           { .init(id: kAudioFilePropertySourceBitDepth) }
//        public static var audioTrackCount: Property<Int>                    { .init(id: kAudioFilePropertyAudioTrackCount) }
        public static var audioDataByteCount: Property<Int>                 { .init(id: kAudioFilePropertyAudioDataByteCount) }
        public static var audioDataPacketCount: Property<Int>               { .init(id: kAudioFilePropertyAudioDataPacketCount) }
        public static var maximumPacketSize: Property<Int>                  { .init(id: kAudioFilePropertyMaximumPacketSize) }
        public static var fileFormat: Property<AudioFilePropertyID>         { .init(id: kAudioFilePropertyFileFormat) }
        public static var dataFormat: Property<AudioStreamBasicDescription> { .init(id: kAudioFilePropertyDataFormat, value: .init()) }
        public static var infoDictionary: Property<NSDictionary>            { .init(id: kAudioFilePropertyInfoDictionary) }
        public static var formatList: Property<AudioFormatListItem>         { .init(id: kAudioFilePropertyFormatList, value: .init()) }

        let id: AudioFilePropertyID
        var value: Value?
        
    }
    
}

public extension STAudioFileService {
    
    func test() throws {
        let propertys: [Property<[CChar]>] = [
            .init(id: kAudioFilePropertyReserveDuration),
            .init(id: kAudioFilePropertyChannelLayout),
            .init(id: kAudioFilePropertyDeferSizeUpdates),
            .init(id: kAudioFilePropertyDataFormatName),
            .init(id: kAudioFilePropertyMarkerList),
            .init(id: kAudioFilePropertyRegionList),
            .init(id: kAudioFilePropertyPacketToFrame),
            .init(id: kAudioFilePropertyFrameToPacket),
            .init(id: kAudioFilePropertyRestrictsRandomAccess),
            .init(id: kAudioFilePropertyPreviousIndependentPacket),
            .init(id: kAudioFilePropertyNextIndependentPacket),
            .init(id: kAudioFilePropertyPacketToDependencyInfo),
            .init(id: kAudioFilePropertyPacketToByte),
            .init(id: kAudioFilePropertyByteToPacket),
            .init(id: kAudioFilePropertyChunkIDs),
            .init(id: kAudioFilePropertyPacketTableInfo),
            .init(id: kAudioFilePropertyID3Tag),
            .init(id: kAudioFilePropertySourceBitDepth),
            .init(id: kAudioFilePropertyAlbumArtwork),
            .init(id: kAudioFilePropertyUseAudioTrack),
            .init(id: kAudioFilePropertyMagicCookieData),
        ]
        
        var index = 0
        for pr in propertys {
            index += 1
            var size: UInt32 = 0
            var status = AudioFileGetPropertyInfo(fd, pr.id, &size, nil)
            
            guard status == noErr else {
                break
            }

            var infoDictionary: AudioChannelLayout = .init()
            status = AudioFileGetProperty(fd, pr.id, &size, &infoDictionary)
            
            guard status == noErr else {
                break
            }
            print(index, " ==> ", infoDictionary)
        }
    }
    
    func propertyInfo(_ property: AudioFilePropertyID) throws -> (size: UInt32, writable: Bool) {
        var size: UInt32 = 0
        var writable: UInt32 = 0
        let status = AudioFileGetPropertyInfo(fd, property, &size, &writable)
        if status != noErr {
            throw error(status: status)
        }
        return (size, writable > 0)
    }
    
    func property<OutputType>(_ property: Property<OutputType>) throws -> OutputType? {
        var property = property
        var (size, _) = try self.propertyInfo(property.id)
        let status = AudioFileGetProperty(fd, property.id, &size, &property.value)
        if status != noErr {
            throw error(status: status)
        }
        return property.value
    }
    
    func setProperty<OutputType>(_ property: Property<OutputType>) throws {
        var property = property
        let (size, _) = try self.propertyInfo(property.id)
        let status = AudioFileSetProperty(fd, property.id, size, &property.value)
        if status != noErr {
            throw error(status: status)
        }
    }
    
    func close() {
        AudioFileClose(fd)
    }
    
    
    func error(status: OSStatus) -> StemError {
        let code = Int(status)
        switch status {
        case kAudioFileUnspecifiedError:               return .init(code: code, message: "OSStatus: file unspecified")
        case kAudioFileUnsupportedDataFormatError:     return .init(code: code, message: "OSStatus: file unsupported data format")
        case kAudioFileUnsupportedPropertyError:       return .init(code: code, message: "OSStatus: file unsupported property")
        case kAudioFileBadPropertySizeError:           return .init(code: code, message: "OSStatus: file bad property size")
        case kAudioFilePermissionsError:               return .init(code: code, message: "OSStatus: file permissions")
        case kAudioFileNotOptimizedError:              return .init(code: code, message: "OSStatus: file not optimized")
        case kAudioFileInvalidChunkError:              return .init(code: code, message: "OSStatus: file invalid chunk")
        case kAudioFileDoesNotAllow64BitDataSizeError: return .init(code: code, message: "OSStatus: file does not allow 64Bit data size")
        case kAudioFileInvalidPacketOffsetError:       return .init(code: code, message: "OSStatus: file invalid packet offset")
        case kAudioFileInvalidPacketDependencyError:   return .init(code: code, message: "OSStatus: file invalid packet dependency")
        case kAudioFileInvalidFileError:               return .init(code: code, message: "OSStatus: file invalid file")
        case kAudioFileOperationNotSupportedError:     return .init(code: code, message: "OSStatus: file operation not supported")
        case kAudioFileNotOpenError:                   return .init(code: code, message: "OSStatus: file not open")
        case kAudioFileEndOfFileError:                 return .init(code: code, message: "OSStatus: file end of file")
        case kAudioFilePositionError:                  return .init(code: code, message: "OSStatus: file position")
        case kAudioFileFileNotFoundError:              return .init(code: code, message: "OSStatus: file not found")
        default:                                       return .init(code: code, message: "OSStatus")
        }
    }
    
}
