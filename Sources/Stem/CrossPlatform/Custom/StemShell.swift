//
//  File.swift
//  
//
//  Created by linhey on 2022/6/28.
//

#if os(macOS)
import Foundation

@available(macOS 11, *)
public struct StemShell { }

@available(macOS 11, *)
public extension StemShell {
    
    static func zsh(_ command: String, environment: [String: String]? = nil, currentDirectoryURL: URL? = nil) throws -> Data {
        try data(["-c", command], environment: environment, executableURL: URL(fileURLWithPath: "/bin/zsh"), currentDirectoryURL: currentDirectoryURL)
    }
    
    @discardableResult
    static func string(_ commands: [String],
                       environment: [String: String]? = nil,
                       executableURL: URL? = nil,
                       currentDirectoryURL: URL? = nil) throws -> String {
        let data = try data(commands,
                            environment: environment,
                            executableURL: executableURL,
                            currentDirectoryURL: currentDirectoryURL)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    @discardableResult
    static func data(_ commands: [String],
                     environment: [String: String]? = nil,
                     executableURL: URL? = nil,
                     currentDirectoryURL: URL? = nil) throws -> Data {
        
        let process = Process()
        process.executableURL = executableURL ?? URL(fileURLWithPath: "/bin/zsh")
        process.arguments = commands
        process.currentDirectoryURL = currentDirectoryURL
        
        if let environment = environment, !environment.isEmpty {
            process.environment = environment
        }
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != .zero {
            if let message = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) {
                throw StemError(message: message)
            }
            
            var message = [String]()
            if let currentDirectory = process.currentDirectoryURL?.path {
                message.append("currentDirectory: \(currentDirectory)")
            }
            message.append("reason: \(process.terminationReason)")
            message.append("code: \(process.terminationReason.rawValue)")
            throw StemError(message: message.joined(separator: "\n"))
        }
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return data
    }
    
}
#endif
