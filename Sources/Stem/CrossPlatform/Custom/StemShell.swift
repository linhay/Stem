#if os(macOS)
import Foundation
import Combine

@available(macOS 11, *)
public struct StemShell { }

protocol AnyShellArguments {
    var arguments: StemShell.Arguments { get }
}

@available(macOS 11, *)
public extension StemShell {
    
    struct Context {
        
        public var environment: [String: String] = [:]
        public var currentDirectory: URL?
        
        public let standardOutput: PassthroughSubject<Data, Never>?
        public var standardError: PassthroughSubject<Data, Never>?
        
        public init(environment: [String : String] = [:],
                    at currentDirectory: URL? = nil,
                    standardOutput: PassthroughSubject<Data, Never>? = .init(),
                    standardError: PassthroughSubject<Data, Never>? = .init()) {
            self.currentDirectory = currentDirectory
            self.standardOutput = standardOutput
            self.standardError = standardError
            var placehoder = ProcessInfo.processInfo.environment
            placehoder["PATH"] = (placehoder["PATH"] ?? "") + ":" + (environment["PATH"] ?? "")
            self.environment = environment.merging(placehoder, uniquingKeysWith: { $1 })
        }
    }
    
    class Standard {
        
        let pipe = Pipe()
        let publisher: PassthroughSubject<Data, Never>?
        
        var availableData: Data? {
            get throws {
                guard let data = _availableData, !data.isEmpty else {
                    return try pipe.fileHandleForReading.readToEnd()
                }
                return data
            }
        }
        
        private var _availableData: Data?
        
        deinit {
            self.pipe.fileHandleForReading.readabilityHandler = nil
        }
        
        init(publisher: PassthroughSubject<Data, Never>?) {
            self.publisher = publisher
        }
        
        func append(to standard: inout Any?) -> Self {
            _availableData = Data()
            standard = pipe
            pipe.fileHandleForReading.readabilityHandler = { [weak self] fh in
                guard let self = self else { return }
                let data = fh.availableData
                if data.isEmpty {
                    self.pipe.fileHandleForReading.readabilityHandler = nil
                } else {
                    self._availableData?.append(data)
                    self.publisher?.send(data)
                }
            }
            return self
        }
    }
    
    enum Shell: String {
        case zsh = "/bin/zsh"
    }
    
    struct ShellArguments: AnyShellArguments {
        
        public var kind: Shell?
        public var command: String
        public var context: Context? = nil
        
        public init(kind: Shell? = nil, command: String, context: Context? = nil) {
            self.kind = kind
            self.command = command
            self.context = context
        }
        
        var arguments: StemShell.Arguments {
            let path = kind?.rawValue ?? context?.environment["SHELL"] ?? "/bin/zsh"
            let exec = URL(fileURLWithPath: path)
            return .init(exec: exec, commands: ["-c", command], context: context)
        }
        
    }
    
    struct Arguments: AnyShellArguments {
        
        public var exec: URL?
        public var commands: [String]
        public var context: Context? = nil
        
        public init(exec: URL? = nil, commands: [String], context: Context? = nil) {
            self.exec = exec
            self.commands = commands
            self.context = context
        }
        
        var arguments: StemShell.Arguments { self }
    }
    
    struct Instance {
        
        public var changedArgsBeforeRun: ((_ args: inout Arguments) -> Void)?
        
        public init() {}
    }
    
}

public extension StemShell.Instance {
    
    @discardableResult
    func shell(_ args: StemShell.ShellArguments) throws -> Data {
        return try data(args.arguments)
    }
    
    @discardableResult
    func shell(string args: StemShell.ShellArguments) throws -> String? {
        let data = try shell(args)
        return String.init(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
    }
    
    @discardableResult
    func string(_ args: StemShell.Arguments) throws -> String {
        let data = try data(args)
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
    }
    
    @discardableResult
    func data(_ args: StemShell.Arguments) throws -> Data {
        var args = args
        changedArgsBeforeRun?(&args)
        let process = self.setupProcess(args.exec, args.commands, context: args.context)
        let output = StemShell.Standard(publisher: args.context?.standardOutput).append(to: &process.standardOutput)
        let error  = StemShell.Standard(publisher: args.context?.standardError).append(to: &process.standardError)
        try process.run()
        process.waitUntilExit()
        return try result(process, output: output.availableData, error: error.availableData).get()
    }
    
    @discardableResult
    func zshPublisher(_ args: StemShell.ShellArguments) -> AnyPublisher<Data, Error> {
        dataPublisher(args.arguments)
    }
    
    @discardableResult
    func zshPublisher(string args: StemShell.ShellArguments) -> AnyPublisher<String?, Error> {
        return zshPublisher(args).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
    
    @discardableResult
    func stringPublisher(_ args: StemShell.Arguments) -> AnyPublisher<String?, Error> {
        return dataPublisher(args).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
    
    @discardableResult
    func dataPublisher(_ args: StemShell.Arguments) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { promise in
            do {
                var args = args
                changedArgsBeforeRun?(&args)
                let process = setupProcess(args.exec, args.commands, context: args.context)
                let output = StemShell.Standard(publisher: args.context?.standardOutput).append(to: &process.standardOutput)
                let error  = StemShell.Standard(publisher: args.context?.standardError).append(to: &process.standardError)
                try process.run()
                process.terminationHandler = { process in
                    do {
                        let data = try result(process, output: output.availableData, error: error.availableData).get()
                        promise(.success(data))
                    } catch {
                        promise(.failure(error))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func result(_ process: Process, output: Data?, error: Data?) -> Result<Data, Error> {
        if process.terminationStatus != .zero {
            if let data = error, let message = String(data: data, encoding: .utf8) {
                return .failure(StemError(message))
            }
            
            if let data = output, let message = String(data: data, encoding: .utf8) {
                return .failure(StemError(message))
            }
            
            var message = [String]()
            if let currentDirectory = process.currentDirectoryURL?.path {
                message.append("currentDirectory: \(currentDirectory)")
            }
            message.append("reason: \(process.terminationReason)")
            message.append("code: \(process.terminationReason.rawValue)")
            return .failure(StemError(message.joined(separator: "\n")))
        }
        return .success(output ?? Data())
    }
    
    func setupProcess(_ exec: URL?, _ commands: [String], context: StemShell.Context? = nil) -> Process {
        let process = Process()
        process.executableURL = exec
        process.arguments = commands
        process.currentDirectoryURL = context?.currentDirectory
        if let environment = context?.environment, !environment.isEmpty {
            process.environment = environment
        }
        return process
    }
    
    
}
public extension StemShell {
    
    private static var shared: Instance { .init() }
    
    @discardableResult
    static func zsh(_ command: String, context: Context? = nil) throws -> Data {
        try shared.shell(.init(kind: .zsh, command: command, context: context))
    }
    
    @discardableResult
    static func zsh(string command: String, context: Context? = nil) throws -> String? {
        try shared.shell(string: .init(kind: .zsh, command: command, context: context))
    }
    
    @discardableResult
    static func string(_ exec: URL?, _ commands: [String], context: Context? = nil) throws -> String {
        try shared.string(.init(exec: exec, commands: commands, context: context))
    }
    
    @discardableResult
    static func data(_ exec: URL?, _ commands: [String], context: Context? = nil) throws -> Data {
        try shared.data(.init(exec: exec, commands: commands, context: context))
    }
    
}

#endif

