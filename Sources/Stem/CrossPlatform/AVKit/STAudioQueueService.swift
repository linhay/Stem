//
//  File.swift
//  
//
//  Created by linhey on 2023/1/11.
//

#if canImport(AVFoundation) && canImport(MediaPlayer)
import Foundation
import Combine
import AVFoundation
import MediaPlayer

@available(iOS 3.0, watchOS 2.0, tvOS 9.0, *)
@available(macOS, unavailable)
open class STAudioQueueService {
    
    public enum PlayMode: Int, Codable, CaseIterable {
        /// 下一首直至列表结束
        case advance
        /// 单曲循环
        case loop
        /// 随机播放
        case random
        /// 列表循环
        case listLoop
        /// 播放完成就停止
        case none
    }
    
    public class Asset: Identifiable, Equatable {
        
        public enum DataProvider {
            case url(URL)
            case data(Data)
            
            public var url: URL? {
                switch self {
                case .url(let value):
                    return value
                case .data:
                    return nil
                }
            }
            
            public var data: Data? {
                switch self {
                case .url:
                    return nil
                case .data(let value):
                    return value
                }
            }
        }
        
        public var id: UUID = .init()
        public let provider: DataProvider
        public var player: STAudioPlayer? { playerSubject.value }
        public var isPlaying: Bool { playerSubject.value?.isPlaying == true }

        public private(set) lazy var playerPublisher = playerSubject.eraseToAnyPublisher()
        public private(set) lazy var timePublisher = timeSubject.eraseToAnyPublisher()
        
        fileprivate lazy var playerSubject = CurrentValueSubject<STAudioPlayer?, Never>(nil)
        private lazy var timeSubject = CurrentValueSubject<STAudioPlayer.Time?, Never>(nil)
        
        private var playerCancellable: AnyCancellable?
        private var timeCancellable: AnyCancellable?

        public init(provider: DataProvider) {
            self.provider = provider
            self.playerCancellable = self.playerPublisher.sink(on: self) { (self, player) in
                if let player = player {
                    self.timeCancellable = player.timePublisher
                        .map({ Optional($0) })
                        .assign(to: \.value, on: self.timeSubject)
                } else {
                    self.timeSubject.send(nil)
                }
            }
        }
        
        public convenience init(url: URL) {
            self.init(provider: .url(url))
        }
        
        public convenience init(data: Data) {
            self.init(provider: .data(data))
        }
        
        public static func == (lhs: Asset, rhs: Asset) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    public var playMode: PlayMode { playModeSubject.value }
    public var current: Asset? { currentAssetSubject.value }
    public var items: [Asset] { itemsSubject.value }
    public var player: STAudioPlayer? { current?.player }

    public private(set) lazy var itemsPublisher = itemsSubject.eraseToAnyPublisher()
    /// Returns an array of the currently enqueued items.
    public private(set) lazy var currentAssetPublisher  = currentAssetSubject.eraseToAnyPublisher()
    public private(set) lazy var currentPlayerPublisher = currentAssetSubject.map(\.?.playerSubject.value).eraseToAnyPublisher()
    public private(set) lazy var historyPublisher       = historySubject.eraseToAnyPublisher()
    public private(set) lazy var playModePublisher      = playModeSubject.eraseToAnyPublisher()
    public private(set) var sessionConfiguration: ((AVAudioSession) throws -> Void)?
    public private(set) var playerConfiguration: STAudioPlayer.Configuration = .init(timeSamplingInterval: nil)

    private let itemsSubject: CurrentValueSubject<[Asset], Never>
    private let modes: [PlayMode]
    
    private lazy var historySubject      = CurrentValueSubject<[Asset], Never>([])
    private lazy var currentAssetSubject = CurrentValueSubject<Asset?, Never>(nil)
    private lazy var playModeSubject     = CurrentValueSubject<PlayMode, Never>(modes.first ?? .none)
    private lazy var cancellables = Set<AnyCancellable>()
    private lazy var playCommands = [Any]()
    
    public init(_ items: [Asset], modes: [PlayMode] = PlayMode.allCases) {
        self.itemsSubject = .init(items)
        self.modes = modes
    }
    
    public convenience init() {
        self.init([Asset]())
    }
    
    public convenience init(_ items: [URL]) {
        self.init(items.map(Asset.init(url:)))
    }
    
    public convenience init(_ items: [Data]) {
        self.init(items.map(Asset.init(data:)))
    }
    
    public func sessionConfiguration(_ value: ((AVAudioSession) throws -> Void)?) {
        self.sessionConfiguration = value
    }
    
    public func playerConfiguration(_ value: STAudioPlayer.Configuration) {
        self.playerConfiguration = value
    }
    
}

@available(iOS 3.0, watchOS 2.0, tvOS 9.0, *)
@available(macOS, unavailable)
public extension STAudioQueueService {
    
    /// 播放特定曲目
    func play(_ item: Asset) throws {        
        if current == item, let player = item.player {
            player.prepareToPlay()
            _ = player.play(atTime: player.deviceCurrentTime)
            return
        }
        
        if historySubject.value.last != item {
            historySubject.value.append(item)
        }
        
        player?.stop()
        current?.playerSubject.send(nil)
        cancellables.removeAll()
        let player: STAudioPlayer
        switch item.provider {
        case .data(let data):
            player = try .init(data: data)
        case .url(let url):
            player = try .init(contentsOf: url)
        }
        player.configuration = self.playerConfiguration
        try self.sessionConfiguration?(AVAudioSession.sharedInstance())
        player.prepareToPlay()
        player.implementationPublisher.sink(on: self) { (self, kind) in
            switch kind {
            case .didFinishPlaying:
                try? self.playNextItem()
            case .decodeErrorDidOccur:
                break
            }
        }.store(in: &cancellables)
        item.playerSubject.send(player)
        currentAssetSubject.send(item)
        _ = player.play()
    }
    
    /// 切换到上一首
    func playPreviousItem() throws {
        guard let previous = historySubject.value.dropLast().last else {
            return
        }
        historySubject.value.removeLast()
        try play(previous)
    }
    
    /// 切换到下一首
    func playNextItem() throws {
        guard let next = nextItem else {
            return
        }
        try play(next)
    }
    
    /// 切换到下一个播放模式
    func switchNextMode() {
        guard let index = modes.firstIndex(of: playModeSubject.value) else {
            return
        }
        playModeSubject.send(modes.value(at: index + 1) ?? modes.first ?? .none)
    }
    
}

@available(iOS 3.0, watchOS 2.0, tvOS 9.0, *)
@available(macOS, unavailable)
public extension STAudioQueueService {
    
    func reset(_ items: [Asset]) {
        player?.stop()
        currentAssetSubject.send(nil)
        current?.playerSubject.send(nil)
        itemsSubject.send(items)
    }
    
    /// Returns a Boolean value that indicates whether you can insert a player item into the player’s queue.
    func canInsert(_ item: Asset, after: Asset?) -> Bool {
        if let after = after {
            return items.firstIndex(of: after) != nil
        } else {
            return true
        }
    }
    
    /// Inserts a player item after another player item in the queue.
    func insert(_ item: Asset, after: Asset?) {
        if let after = after {
            if let index = items.firstIndex(of: after) {
                itemsSubject.value.insert(item, at: index + 1)
            }
        } else {
            itemsSubject.value.insert(item, at: 0)
        }
    }
    
    /// Removes a given player item from the queue.
    func remove(_ item: Asset) {
        if current == item {
            currentAssetSubject.send(nil)
            current?.playerSubject.send(nil)
        }
        guard let index = items.firstIndex(of: item) else {
            return
        }
        itemsSubject.value.remove(at: index)
    }
    
    /// Removes all player items from the queue.
    func removeAllItems() {
        self.itemsSubject.value.removeAll()
    }
    
    /// Ends playback of the current item and starts playback of the next item in the player’s queue.
    var nextItem: Asset? {
        if items.isEmpty {
            return nil
        }
        switch playMode {
        case .advance:
            guard let currentIndex = items.firstIndex(where: { current == $0 }) else {
                return items.first
            }
            return items.value(at: currentIndex + 1)
        case .listLoop:
            guard let currentIndex = items.firstIndex(where: { current == $0 }) else {
                return items.first
            }
            return items.value(at: currentIndex + 1) ?? items.first
        case .loop:
            return current
        case .random:
            return items.randomElement()
        case .none:
            return nil
        }
    }
    
}

@available(iOS 3.0, watchOS 2.0, tvOS 9.0, *)
@available(macOS, unavailable)
public extension STAudioQueueService {
    
    func setupRemoteCenterCommands() {
        var commands = [Any]()
        let center = MPRemoteCommandCenter.shared()
        commands.append(center.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            if let player = self.player {
                _ = player.play()
            } else {
                try? self.playNextItem()
            }
            return .success
        })
        
        commands.append(center.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            self.player?.pause()
            return .success
        })
        
        commands.append(center.nextTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            try? self.playNextItem()
            return .success
        })
        
        commands.append(center.previousTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            try? self.playPreviousItem()
            return .success
        })
        
        commands.append(center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            let currentTime = (event as! MPChangePlaybackPositionCommandEvent).positionTime
            self.player?.currentTime = currentTime
            return .success
        })
        
        commands.append(center.togglePlayPauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .noSuchContent }
            if self.player?.isPlaying == true {
                self.player?.pause()
            } else {
                _ = self.player?.play()
            }
            return .success
        })
        
        self.playCommands = commands
    }
    
}

#endif
