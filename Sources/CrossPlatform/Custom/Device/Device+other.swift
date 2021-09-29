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

import Foundation

public extension Device {
    
    /// SwiftUI app is in preview mode
    static var isPreviews: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static let isSimulator = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()
    
    /// ptrace 用于拒绝调试 可以比较有效的保护 app
    static func refusalDebug() {
        #if !DEBUG
        typealias ptrace = @convention(c) (_ request: Int, _ pid: Int, _ addr: Int, _ data: Int) -> AnyObject
        let open = dlopen("/usr/lib/system/libsystem_kernel.dylib", RTLD_NOW)
        guard unsafeBitCast(open, to: Int.self) > 0x1024,
              let result = dlsym(open, "ptrace") else {
            return
        }
        unsafeBitCast(result, to: ptrace.self)(0x1F, 0, 0, 0)
        #endif
    }
    
    
    /// 是否越狱
    static let isJailbroken = { () -> Bool in 
        if isSimulator { return false }
        let paths = ["/Applications/Cydia.app", "/private/var/lib/apt/", "/private/var/lib/cydia", "/private/var/stash"]
        
        if paths.first(where: { return FileManager.default.fileExists(atPath: $0) }) != nil { return true }
        
        if let bash = fopen("/bin/bash", "r") {
            fclose(bash)
            return true
        }
        
        if let uuid = CFUUIDCreate(nil),
           let string = CFUUIDCreateString(nil, uuid) {
            let path = "/private/" + (string as String)
            do {
                try "test".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                
            }
        }
        return false
    }()
    
}
