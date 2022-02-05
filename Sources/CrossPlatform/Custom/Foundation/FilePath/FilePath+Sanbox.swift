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

public extension FilePath.Folder {

    static let home = try! FilePath.Folder(sanbox: .home)
    
    /// iOS 沙盒路径
    enum SanboxRootPath {
        case root
        case home
        case document
        case library
        case cache
        case temporary

        var path: String? {
            try? url().path
        }
        
        func url() throws -> URL {
            let manager = FileManager.default
            switch self {
            case .root:
                return URL(string: NSOpenStepRootDirectory())!
            case .home:
                return URL(string: NSHomeDirectory())!
            case .document:
                return try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            case .library:
                return try manager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            case .cache:
                return try manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            case .temporary:
                return URL(fileURLWithPath: NSTemporaryDirectory())
            }
        }

    }

    init(sanbox rootPath: SanboxRootPath) throws {
        self.init(url: try rootPath.url())
    }

}
