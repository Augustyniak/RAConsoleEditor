//
//  NSObject_Extension.swift
//
//  Created by Rafal Augustyniak on 08/03/16.
//  Copyright © 2016 Rafał Augustyniak. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = RAConsoleEditor(bundle: bundle)
        	}
        }
    }
}