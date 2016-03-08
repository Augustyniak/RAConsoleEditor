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

import Foundation

enum FileCreatorErrors : ErrorType, CustomStringConvertible {
    case CannotCreateFileInSpecifiedDirectory(directoryURL: NSURL)
    
    var description: String {
        get {
            switch self {
            case let .CannotCreateFileInSpecifiedDirectory(directorURL):
                if let directoryPath = directorURL.path {
                    return NSLocalizedString("Cannot create file in directory at path \"\(directoryPath)\".", comment: "")
                } else {
                    return NSLocalizedString("Cannot create file in specified directory.", comment: "")
                }
            }
        }
    }
}

struct FilePathTemplate {
    let pathTemplate: String
    let suffixLength: Int32
}

class FileCreator {
    
    let fileManager: NSFileManager
    
    init(fileManager: NSFileManager) {
        self.fileManager = fileManager
    }
    
    private func fileNameTemplateForCurrentDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        return NSLocalizedString("Console Logs ", comment: "") + dateFormatter.stringFromDate(NSDate())
    }
    
    func getUniquePathTemplateForFile(inDirectoryAtPath directoryPath: String) -> FilePathTemplate {
        let kFileExtension = ".txt"
        let tempFileTemplate = (directoryPath as NSString).stringByAppendingPathComponent(fileNameTemplateForCurrentDate()) + "-XX" + kFileExtension
        let tempFileTemplateCString = (tempFileTemplate as NSString).fileSystemRepresentation
        
        let allocatedSize = Int(strlen(tempFileTemplateCString)) + 1;
        let tempFileNameCString = UnsafeMutablePointer<Int8>(malloc(allocatedSize))
        defer {
            tempFileNameCString.destroy()
            tempFileNameCString.dealloc(allocatedSize)
        }
        strncpy(tempFileNameCString, tempFileTemplateCString, allocatedSize)
        
        let pathTemplateInSystemRepresentation = fileManager.stringWithFileSystemRepresentation(tempFileNameCString, length: Int(strlen(tempFileNameCString)))
        return FilePathTemplate(pathTemplate: pathTemplateInSystemRepresentation, suffixLength: Int32(kFileExtension.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    }
    
    func createFileHandlerForUniquelyNamedFileInDirectory(atURL directoryURL: NSURL) throws -> FileHandle {
        guard let directoryPath = directoryURL.path else {
            throw FileCreatorErrors.CannotCreateFileInSpecifiedDirectory(directoryURL: directoryURL)
        }
        let filePathTemplate = getUniquePathTemplateForFile(inDirectoryAtPath: directoryPath)
        let fileCPathTemplate = UnsafeMutablePointer<Int8>((filePathTemplate.pathTemplate as NSString).fileSystemRepresentation);
        
        let fileDescriptor = mkstemps(fileCPathTemplate, filePathTemplate.suffixLength);
        
        if fileDescriptor == -1 {
            throw FileCreatorErrors.CannotCreateFileInSpecifiedDirectory(directoryURL: directoryURL)
        } else {
            let tempFileName = fileManager.stringWithFileSystemRepresentation(fileCPathTemplate, length: Int(strlen(fileCPathTemplate)))
            let fileURL = NSURL.init(fileURLWithPath: tempFileName);
            return FileHandle.init(fileDescriptor: fileDescriptor, fileURL: fileURL);
        }
    }
    
}
