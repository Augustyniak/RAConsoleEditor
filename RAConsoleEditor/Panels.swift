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

extension NSOpenPanel {
    
    static func askUserToChooseApplication() -> String? {
        let openPanel = NSOpenPanel.init()
        openPanel.directoryURL = applicationFolderURL()
        openPanel.allowedFileTypes = ["app"]
        openPanel.allowsMultipleSelection = false
        openPanel.title = NSLocalizedString("Choose Application", comment: "")
        
        guard openPanel.runModal() == NSFileHandlingPanelOKButton, let applicationURL = openPanel.URLs.first else {
            return nil
        }
        
        return NSBundle.init(URL: applicationURL)?.bundleIdentifier
    }
    
    static func applicationFolderURL() -> NSURL {
        let applicationDirectoryURLs = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationDirectory, inDomains: NSSearchPathDomainMask.LocalDomainMask)
        
        if let applicationDirectoryURL = applicationDirectoryURLs.first {
            return applicationDirectoryURL
        } else {
            return NSURL.init(string: "/Applications")!
        }
    }
    
    static func askUserToChooseDirectory(defaultDestinationDirectoryURL: NSURL) -> NSURL? {
        let openPanel = NSOpenPanel.init()
        openPanel.directoryURL = defaultDestinationDirectoryURL
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.title = NSLocalizedString("Choose Directory", comment: "")
        
        guard openPanel.runModal() == NSFileHandlingPanelOKButton, let directoryURL = openPanel.URLs.first else {
            return nil
        }
        
        return directoryURL
    }
    
}

extension NSSavePanel {
    
    static func askUserToChooseSaveDestination(defaultDestinationDirectoryURL: NSURL) -> NSURL? {
        let savePanel = NSSavePanel.init()
        savePanel.directoryURL = defaultDestinationDirectoryURL
        savePanel.title = NSLocalizedString("Choose save location", comment: "")
        guard savePanel.runModal() == NSFileHandlingPanelOKButton, let URL = savePanel.URL else {
            return nil
        }
        
        return URL
    }
    
}

extension NSAlert {
    
    static func showAlert(messageText: String, informativeText: String) {
        let alert = NSAlert.init()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
        alert.runModal()
    }
    
    static func showAlert(error: ErrorType) {
        let messageText = NSLocalizedString("Error. Operation cannot be performed.", comment: "")
        if let error = error as? CustomStringConvertible {
            showAlert(messageText, informativeText: error.description)
        } else {
            showAlert(messageText, informativeText: NSLocalizedString("", comment: ""))
        }
    }
    
}
