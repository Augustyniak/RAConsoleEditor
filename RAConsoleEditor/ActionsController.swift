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

class ActionsController : NSObject {
    
    let fileController: FileController
    let textInputInterface: TextInputInterface
    let settingsStorage: SettingsStorage
    let fileOpener: FileOpener
    
    init(fileController: FileController, textInput: TextInputInterface, settingsStorage: SettingsStorage, fileOpener: FileOpener) {
        self.fileController = fileController
        self.fileController.directoryURL = settingsStorage.defaultDirectoryLocationURL
        self.textInputInterface = textInput
        self.settingsStorage = settingsStorage
        self.fileOpener = fileOpener
    }
    
    func saveAndOpenFileWithTextEditor() {
        let fileURL: NSURL
        do {
            fileURL = try fileController.saveString(self.textInputInterface.text ?? "", directoryURL: settingsStorage.defaultDirectoryLocationURL)
            guard let path = fileURL.path else { return }
            let directoryPath = (path as NSString).stringByDeletingLastPathComponent
            settingsStorage.defaultDirectoryLocationURL = NSURL(fileURLWithPath: directoryPath)
        } catch let error {
            NSAlert.showAlert(error)
            return
        }
        
        
        let askUserToChooseApplicationAndOpenFile = {() in
            guard let applicationBundleIdentifier = NSOpenPanel.askUserToChooseApplication() else {
                return
            }
            self.settingsStorage.defaultTextEditorBundleIdentifier = applicationBundleIdentifier
            self.fileOpener.openFile(fileURL, withApplicationWithBundleIdentifier: applicationBundleIdentifier)
        }
        
        if let defaultTextEditorBundleIdentifier = settingsStorage.defaultTextEditorBundleIdentifier {
            if !self.fileOpener.openFile(fileURL, withApplicationWithBundleIdentifier: defaultTextEditorBundleIdentifier) {
                settingsStorage.defaultTextEditorBundleIdentifier = nil
                askUserToChooseApplicationAndOpenFile()
            }
        } else {
            askUserToChooseApplicationAndOpenFile()
        }
    }
    
    func chooseDefaultTextEditor() {
        guard let applicationBundleIdentifier = NSOpenPanel.askUserToChooseApplication() else {
            return
        }
        
        settingsStorage.defaultTextEditorBundleIdentifier = applicationBundleIdentifier
    }
    
    func saveFile() {
        do {
            try fileController.saveString(self.textInputInterface.text ?? "", directoryURL: settingsStorage.defaultDirectoryLocationURL)
        } catch let error {
            NSAlert.showAlert(error)
        }
    }
    
    func saveFileAs() {
        guard let URL = NSSavePanel.askUserToChooseSaveDestination(settingsStorage.defaultDirectoryLocationURL) else {
            return
        }
        
        do {
            try fileController.saveString(self.textInputInterface.text ?? "", fileURL: URL)
        } catch let error {
            NSAlert.showAlert(error)
        }
    }
    
    func explore() {
        var directoryURL = settingsStorage.defaultDirectoryLocationURL
        do {
            try fileController.createDirectoryIfNotExist(directoryURL)
        } catch let error {
            directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
            settingsStorage.defaultDirectoryLocationURL = directoryURL
            NSAlert.showAlert(error)
        }
        
        NSWorkspace.sharedWorkspace().openURL(directoryURL)
    }
    
    func chooseDefaultDestinationPath() {
        guard let directoryURL = NSOpenPanel.askUserToChooseDirectory(settingsStorage.defaultDirectoryLocationURL) else {
            return
        }
        
        fileController.directoryURL = directoryURL
        settingsStorage.defaultDirectoryLocationURL = directoryURL
    }
    
}
