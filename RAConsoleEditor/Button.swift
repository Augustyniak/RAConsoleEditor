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

class RAButton : NSButton {
    
    var eventMonitorRegistrationObject: AnyObject? = nil
    let defaultTitle: String
    var defaultAction: Selector?
    var alternateAction: Selector?
    
    required init?(coder: NSCoder) {
        self.defaultTitle = ""
        super.init(coder: coder)
    }
    
    init(frame frameRect: NSRect, defaultTitle: String, alternateTitle: String?, defaultAction: Selector? = nil, alternateAction: Selector? = nil) {
        self.defaultTitle = defaultTitle
        self.defaultAction = defaultAction
        self.alternateAction = alternateAction
        super.init(frame: frameRect)
        if let alternateTitle = alternateTitle {
            self.alternateTitle = alternateTitle
        }
        
        eventMonitorRegistrationObject = NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: { (event) -> NSEvent? in
            if (event.modifierFlags.rawValue & NSEventModifierFlags.AlternateKeyMask.rawValue) != 0 {
                self.title = self.alternateTitle ?? self.defaultTitle
            } else {
                self.title = self.defaultTitle
            }
            
            self.action = self.actionForCurrentButtonState() ?? Selector()
            
            return event
        })
    }
    
    func actionForCurrentButtonState() -> Selector? {
        if title == defaultTitle {
            return defaultAction
        } else {
            return alternateAction
        }
    }
    
    deinit {
        guard let eventMonitorRegistrationObject = self.eventMonitorRegistrationObject else {
            return
        }
        NSEvent.removeMonitor(eventMonitorRegistrationObject)
    }
    
}
