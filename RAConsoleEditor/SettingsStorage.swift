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

enum Keys: String {
    case DefaultTextEditBundleIdentifier = "DefaultTextEditBundleIdentifier"
    case DefaultFileLocationPath = "DefaultFileLocationPath"
}

class SettingsStorage {
    
    let userDefaults: NSUserDefaults
    let identifier: String
    
    init(identifier: String = "RAOpenConsoleLogsInEditor", userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
        self.identifier = identifier
        self.userDefaults = userDefaults
        
        let defaultDirectoryPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("RAOpenConsoleLogsInEditor")
        userDefaults.removeObjectForKey(keyForProperty(withName: Keys.DefaultFileLocationPath.rawValue))
        userDefaults.registerDefaults([
            keyForProperty(withName: Keys.DefaultFileLocationPath.rawValue) : defaultDirectoryPath
            ]);
    }
    
    var defaultTextEditorBundleIdentifier: String? {
        get {
            return userDefaults.stringForKey(keyForProperty(withName: Keys.DefaultTextEditBundleIdentifier.rawValue))
        }
        set {
            userDefaults.setObject(newValue, forKey: keyForProperty(withName: Keys.DefaultTextEditBundleIdentifier.rawValue))
        }
    }
    
    var defaultDirectoryLocationURL: NSURL {
        get {
            return NSURL(fileURLWithPath: userDefaults.stringForKey(keyForProperty(withName: Keys.DefaultFileLocationPath.rawValue))!)
        }
        set {
            userDefaults.setObject(newValue.path, forKey: keyForProperty(withName: Keys.DefaultFileLocationPath.rawValue))
        }
    }
    
    func keyForProperty(withName name: String) -> String {
        return identifier + name
    }
    
}
