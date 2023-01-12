//
//  File.swift
//  
//
//  Created by linhey on 2023/1/11.
//

#if canImport(AVFoundation)
import AVFoundation
import Combine

open class STAudioPlayer: AVAudioPlayer {
    
    public struct Configuration {
        /// 时间采样间隔
        public var timeSamplingInterval: TimeInterval?
        
        public init(timeSamplingInterval: TimeInterval?) {
            self.timeSamplingInterval = timeSamplingInterval
        }
    }
    
    public enum ImplementationKind {
        case didFinishPlaying(successfully: Bool)
        case decodeErrorDidOccur(error: Error?)
    }
    
    public enum State: Int, Codable {
        case play
        case pause
        case stop
    }
    
    public struct Time: Codable, Equatable, Hashable {
        
        public let duration: TimeInterval
        public let current: TimeInterval
        
        public var progress: TimeInterval {
            let value = current / duration
            if value.isNaN || value.isInfinite {
                return 0
            }
            return value
        }
        
        public init(duration: TimeInterval, current: TimeInterval) {
            self.duration = duration
            self.current = current
        }
    }
    
    public lazy var configuration = Configuration(timeSamplingInterval: nil)
    public private(set) lazy var timePublisher  = timeSubject.eraseToAnyPublisher()
    public private(set) lazy var statePublisher = stateSubject.removeDuplicates().eraseToAnyPublisher()
    public private(set) lazy var implementationPublisher = implementation.subject.eraseToAnyPublisher()

    private lazy var implementation = STAudioPlayerImplementation()
    private lazy var stateSubject   = CurrentValueSubject<State, Never>(.stop)
    private lazy var timeSubject    = CurrentValueSubject<Time, Never>(.init(duration: duration, current: currentTime))
    
    private var timeCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    /*  If the sound is playing, currentTime is the offset into the sound of the current playback position.
     If the sound is not playing, currentTime is the offset into the sound where playing would start. */
    override open var currentTime: TimeInterval {
        get { super.currentTime }
        set {
            DispatchQueue.global(qos: .userInteractive).async {
                super.currentTime = newValue
            }
        }
    }
    
    /* Transport control */
    /* Methods that return BOOL return YES on success and NO on failure. */
    /* Get ready to play the sound. This happens automatically on play. */
    // open func prepareToPlay() -> Bool
    
    
    /* This method starts the audio hardware synchronously (if not already running), and triggers the sound playback which is streamed asynchronously. */
    open override func play() -> Bool {
        stateSubject.send(.play)
        return super.play()
    }
    
    /* This method starts the audio hardware synchronously (if not already running), and triggers the sound playback which is streamed asynchronously at the specified time in the future.
     Time is an absolute time based on and greater than deviceCurrentTime. */
    @available(macOS 10.7, *)
    open override func play(atTime time: TimeInterval) -> Bool {
        stateSubject.send(.play)
        return super.play(atTime: time)
    }
    
    
    /* Pauses playback, but remains ready to play. */
    open override func pause() {
        stateSubject.send(.pause)
        super.pause()
    }
    
    
    /* Synchronously stops playback, no longer ready to play.
     NOTE: - This will block while releasing the audio hardware that was acquired upon calling play() or prepareToPlay() */
    open override func stop() {
        stateSubject.send(.stop)
        super.stop()
    }
    
    
    /* properties */
    
    //    open var isPlaying: Bool { get } /* is it playing or not? */
    
    
    //    open var numberOfChannels: Int { get }
    
    //    open var duration: TimeInterval { get } /* the duration of the sound. */
    
    
    /* the UID of the current audio device (as a string) */
    //    @available(macOS 10.13, *)
    //    open var currentDevice: String?
    
    /* one of these properties will be non-nil based on the init... method used */
    //    open var url: URL? { get } /* returns nil if object was not created with a URL */
    
    //    open var data: Data? { get } /* returns nil if object was not created with a data object */
    
    
    //    @available(macOS 10.7, *)
    //    open var pan: Float /* set panning. -1.0 is left, 0.0 is center, 1.0 is right. */
    
    //    open var volume: Float /* The volume for the sound. The nominal range is from 0.0 to 1.0. */
    
    //    @available(macOS 10.12, *)
    //    open func setVolume(_ volume: Float, fadeDuration duration: TimeInterval) /* fade to a new volume over a duration */
    
    
    //    @available(macOS 10.8, *)
    //    open var enableRate: Bool /* You must set enableRate to YES for the rate property to take effect. You must set this before calling prepareToPlay. */
    
    //    @available(macOS 10.8, *)
    //    open var rate: Float /* See enableRate. The playback rate for the sound. 1.0 is normal, 0.5 is half speed, 2.0 is double speed. */
    
    
    /* returns the current time associated with the output device */
    //    @available(macOS 10.7, *)
    //    open var deviceCurrentTime: TimeInterval { get }
    
    
    /* "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
     A value of zero means to play the sound just once.
     A value of one will result in playing the sound twice, and so on..
     Any negative number will loop indefinitely until stopped.
     */
    //    open var numberOfLoops: Int
    
    
    /* settings */
    //    @available(macOS 10.7, *)
    //    open var settings: [String : Any] { get } /* returns a settings dictionary with keys as described in AVAudioSettings.h */
    
    
    /* returns the format of the audio data */
    //    @available(macOS 10.12, *)
    //    open var format: AVAudioFormat { get }
    
    
    /* metering */
    
    //    open var isMeteringEnabled: Bool /* turns level metering on or off. default is off. */
    
    
    //    open func updateMeters() /* call to refresh meter values */
    
    
    //    open func peakPower(forChannel channelNumber: Int) -> Float /* returns peak power in decibels for a given channel */
    
    //    open func averagePower(forChannel channelNumber: Int) -> Float /* returns average power in decibels for a given channel */
    
    open func initialize() {
        self.delegate = implementation
        statePublisher.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .play:
                self.startTimer()
            case .pause:
                self.timeCancellable = nil
            case .stop:
                self.timeCancellable = nil
            }
        }.store(in: &cancellables)
    }
    
    public override init() {
        super.init()
        initialize()
    }
    
    /* For all of these init calls, if a return value of nil is given you can check outError to see what the problem was.
     If not nil, then the object is usable for playing
     */
    
    /* all data must be in the form of an audio file understood by CoreAudio */
    public override init(contentsOf url: URL) throws {
        try super.init(contentsOf: url)
        initialize()
    }
    
    public override init(data: Data) throws {
        try super.init(data: data)
        initialize()
    }
    
    /* The file type hint is a constant defined in AVMediaFormat.h whose value is a UTI for a file format. e.g. AVFileTypeAIFF. */
    /* Sometimes the type of a file cannot be determined from the data, or it is actually corrupt. The file type hint tells the parser what kind of data to look for so that files which are not self identifying or possibly even corrupt can be successfully parsed. */
    @available(macOS 10.9, *)
    public override init(contentsOf url: URL, fileTypeHint utiString: String?) throws {
        try super.init(contentsOf: url, fileTypeHint: utiString)
        initialize()
    }
    
    @available(macOS 10.9, *)
    public override init(data: Data, fileTypeHint utiString: String?) throws {
        try super.init(data: data, fileTypeHint: utiString)
        initialize()
    }
    
}

private extension STAudioPlayer {
    
    func startTimer() {
        guard let timeSamplingInterval = configuration.timeSamplingInterval else {
            timeCancellable = nil
            return
        }
        timeCancellable = Timer
            .publish(every: timeSamplingInterval, on: .main, in: .common)
            .autoconnect()
            .sink(on: self) { (self, _) in
                self.timeSubject.send(.init(duration: self.duration, current: self.currentTime))
            }
    }
    
}

private class STAudioPlayerImplementation: NSObject, AVAudioPlayerDelegate {
    
    lazy var subject = PassthroughSubject<STAudioPlayer.ImplementationKind, Never>()

    /* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        subject.send(.didFinishPlaying(successfully: flag))
    }
    
    /* if an error occurs while decoding it will be reported to the delegate. */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        subject.send(.decodeErrorDidOccur(error: error))
    }
    
}

#endif
