#if os(macOS)
import Foundation
import Combine

@available(macOS 11, *)
public struct StemShell { }

@available(macOS 11, *)
public extension StemShell {
    
    struct Context {
        
        public var environment: [String: String]
        public var currentDirectory: URL?
        
        public let standardOutput: PassthroughSubject<Data, Never>?
        public var standardError: PassthroughSubject<Data, Never>?
        
        public init(environment: [String : String] = [:],
                    at currentDirectory: URL? = nil,
                    standardOutput: PassthroughSubject<Data, Never>? = .init(),
                    standardError: PassthroughSubject<Data, Never>? = .init()) {
            self.environment = environment
            self.currentDirectory = currentDirectory
            self.standardOutput = standardOutput
            self.standardError = standardError
            
            let libs = ["/bin", "/sbin",
                        "/usr/bin", "/usr/sbin",
                        "/opt/homebrew/bin", "/opt/homebrew/sbin",
                        "/usr/local/bin", "/usr/local/sbin",
                        "/usr/local/opt/ruby/bin", "/Library/Apple/usr/bin"]
            if var paths = ProcessInfo.processInfo.environment["PATH"]?.split(separator: ":").map({ String($0) }), !paths.isEmpty {
                paths.append(contentsOf: libs)
                self.environment["PATH"] = Set(paths).joined(separator: ":")
            } else {
                self.environment["PATH"] = Set(libs).joined(separator: ":")
            }
            
#if arch(arm64)
            
#elseif arch(x86_64)
            if self.environment["SSH_AUTH_SOCK"] == nil {
                self.environment["SSH_AUTH_SOCK"] = ProcessInfo.processInfo.environment["SSH_AUTH_SOCK"]
            }
#endif
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
    
}

public extension StemShell {
    
    @discardableResult
    static func zsh(_ command: String, context: Context? = nil) throws -> Data {
        let path = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        return try data(URL(fileURLWithPath: path), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zsh(string command: String, context: Context? = nil) throws -> String? {
        let data = try zsh(command, context: context)
        return String.init(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
    }
    
    @discardableResult
    static func string(_ exec: URL?, _ commands: [String], context: Context? = nil) throws -> String {
        let data = try data(exec, commands, context: context)
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
    }
    
    @discardableResult
    static func data(_ exec: URL?, _ commands: [String], context: Context? = nil) throws -> Data {
        let process = self.setupProcess(exec, commands, context: context)
        let output = Standard(publisher: context?.standardOutput).append(to: &process.standardOutput)
        let error  = Standard(publisher: context?.standardError).append(to: &process.standardError)
        try process.run()
        process.waitUntilExit()
        return try result(process, output: output.availableData, error: error.availableData).get()
    }
    
}

public extension StemShell {
    
    @discardableResult
    static func zshPublisher(_ command: String, context: Context? = nil) -> AnyPublisher<Data, Error> {
        dataPublisher(URL(fileURLWithPath: "/bin/zsh"), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zshPublisher(string command: String, context: Context? = nil) -> AnyPublisher<String?, Error> {
        return zshPublisher(command, context: context).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
    
    @discardableResult
    static func stringPublisher(_ exec: URL?, _ commands: [String], context: Context? = nil) -> AnyPublisher<String?, Error> {
        return dataPublisher(exec, commands, context: context).map { String(data: $0, encoding: .utf8) }.eraseToAnyPublisher()
    }
    
    @discardableResult
    static func dataPublisher(_ exec: URL?, _ commands: [String], context: Context? = nil) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { promise in
            do {
                let process = self.setupProcess(exec, commands, context: context)
                let output = Standard(publisher: context?.standardOutput).append(to: &process.standardOutput)
                let error  = Standard(publisher: context?.standardError).append(to: &process.standardError)
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
    
}

public extension StemShell {
    
    @discardableResult
    static func zsh(_ command: String, context: Context? = nil) async throws -> Data {
        try await data(URL(fileURLWithPath: "/bin/zsh"), ["-c", command], context: context)
    }
    
    @discardableResult
    static func zsh(string command: String, context: Context? = nil) async throws -> String? {
        let data = try await zsh(command, context: context)
        return String(data: data, encoding: .utf8)
    }
    
    @discardableResult
    static func string(_ exec: URL?, _ commands: [String], context: Context? = nil) async throws -> String {
        let data = try await data(exec, commands, context: context)
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines) ?? ""
    }
    
    @discardableResult
    static func data(_ exec: URL?, _ commands: [String], context: Context? = nil) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                let process = self.setupProcess(exec, commands, context: context)
                let output = Standard(publisher: context?.standardOutput).append(to: &process.standardOutput)
                let error  = Standard(publisher: context?.standardError).append(to: &process.standardError)
                try process.run()
                process.terminationHandler = { process in
                    do {
                        let data = try result(process, output: output.availableData, error: error.availableData).get()
                        continuation.resume(with: .success(data))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
}

private extension StemShell {
    
    static func result(_ process: Process, output: Data?, error: Data?) -> Result<Data, Error> {
        if process.terminationStatus != .zero {
            if let data = error, let message = String(data: data, encoding: .utf8) {
                return .failure(StemError(message: message))
            }
            
            if let data = output, let message = String(data: data, encoding: .utf8) {
                return .failure(StemError(message: message))
            }
            
            var message = [String]()
            if let currentDirectory = process.currentDirectoryURL?.path {
                message.append("currentDirectory: \(currentDirectory)")
            }
            message.append("reason: \(process.terminationReason)")
            message.append("code: \(process.terminationReason.rawValue)")
            return .failure(StemError(message: message.joined(separator: "\n")))
        }
        return .success(output ?? Data())
    }
    
    static func setupProcess(_ exec: URL?, _ commands: [String], context: Context? = nil) -> Process {
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

#endif

