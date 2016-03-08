//
//  Copyright (c) 2016 Rafał Augustyniak
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import AppKit

enum FileControllerErrors: ErrorType, CustomStringConvertible {
    case CannotCreateFileAtSpecifiedLocation(URL: NSURL)
    case EncodingError
    
    var description: String {
        get {
            switch self {
            case let .CannotCreateFileAtSpecifiedLocation(URL):
                if let path = URL.path {
                    return NSLocalizedString("Cannot create file at path \"\(path)\".", comment: "")
                } else {
                    return NSLocalizedString("Cannot create file.", comment: "")
                }
            case .EncodingError:
                return NSLocalizedString("Cannot encode content in order to store it in file.", comment: "")
            }
        }
    }
}


class FileController {
    
    var directoryURL: NSURL
    let fileManager: NSFileManager
    let fileCreator: FileCreator
    
    init(fileManager: NSFileManager = NSFileManager.defaultManager(), directoryURL: NSURL = NSURL(fileURLWithPath: NSTemporaryDirectory())) {
        self.directoryURL = directoryURL
        self.fileManager = fileManager
        self.fileCreator = FileCreator(fileManager: fileManager)
    }
    
    func saveString(string: String, fileURL: NSURL) throws {
        try createFileIfNotExist(fileURL)
        let fileHandle = try NSFileHandle(forWritingToURL: fileURL)
        
        guard let data = string.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw FileControllerErrors.EncodingError
        }
        
        fileHandle.writeData(data)
        fileHandle.closeFile()
    }
    
    func saveString(string: String, directoryURL: NSURL) throws -> NSURL {
        try createDirectoryIfNotExist(directoryURL)
        
        let fileHandle = try fileCreator.createFileHandlerForUniquelyNamedFileInDirectory(atURL: directoryURL)
        fileHandle.writeString(string)
        
        return fileHandle.fileURL
    }
    
    func createDirectoryIfNotExist(directoryURL: NSURL) throws {
        if !fileManager.fileExistsAtPath(directoryURL.path!) {
            try fileManager.createDirectoryAtURL(directoryURL, withIntermediateDirectories: false, attributes: [:])
        }
    }
    
    private func createFileIfNotExist(fileURL: NSURL) throws {
        guard let path = fileURL.path else {
            throw FileControllerErrors.CannotCreateFileAtSpecifiedLocation(URL: fileURL)
        }
        
        let directoryURL = NSURL(fileURLWithPath:(path as NSString).stringByDeletingLastPathComponent)
        
        try createDirectoryIfNotExist(directoryURL)
        if !fileManager.fileExistsAtPath(path) {
            fileManager.createFileAtPath(path, contents: nil, attributes: [:])
        }
    }
    
}
