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

class ScopeBarInterface {
    
    let scopeBarView: NSView
    
    init(withScopeBarView scopeBarView: NSView) {
        self.scopeBarView = scopeBarView;
    }
    
    private func getTwoFarestViews() -> (NSView, NSView)? {
        guard scopeBarView.subviews.count >= 2 else {
            return nil
        }
        
        let leftToRightSubviews = scopeBarView.subviews.sort({ (a, b) -> Bool in
            return a.frame.right() < b.frame.right()
        })
        
        var result = (scopeBarView.subviews.first!, scopeBarView.subviews.last!)
        var distance = CGFloat.min
        for i in 0...scopeBarView.subviews.count - 2 {
            let leftSubview = leftToRightSubviews[i]
            let rightSubview = leftToRightSubviews[i+1]
            let innerLoopDistance =  rightSubview.frame.left() - leftSubview.frame.right()
            if (innerLoopDistance > distance) {
                distance = innerLoopDistance
                result = (leftSubview, rightSubview)
            }
        }
        
        return result;
    }
    
    func getViewWhichShouldBeLeftNeighbourOfOpenInEditorButton() -> NSView? {
        return getTwoFarestViews()?.0;
    }
    
}


protocol TextInputInterface {
    var text: String? { get }
}


class ConsoleViewInterface : TextInputInterface {
    
    var text: String? {
        get {
            return consoleTextView?.textStorage?.string
        }
    }
    
    var consoleTextView: NSTextView? {
        get {
            return ConsoleViewInterface.getViewByClassName("IDEConsoleTextView") as? NSTextView
        }
    }
    
    var consoleScopeBarInterface: ScopeBarInterface? {
        get {
            guard let consoleTextView = self.consoleTextView else {
                return nil;
            }
            
            guard let parentView = consoleTextView.getParentViewWithClass(["DVTControllerContentView", "DVTControllerContentView_ControlledBy_IDEConsoleArea"]) else {
                return nil
            }
        
            let scopeBarView =  ConsoleViewInterface.getViewByClassName("DVTScopeBarView", inContainerView: parentView);
            if let scopeBarView = scopeBarView {
                return ScopeBarInterface(withScopeBarView: scopeBarView)
            } else {
                return nil
            }
            
        }
    }
    
    private static func getViewByClassName(name: String) -> NSView? {
        return getViewByClassName(name, inContainerView: NSApp.mainWindow?.contentView);
    }
    
    private static func getViewByClassName(name: String, inContainerView containerView: NSView?) -> NSView? {
        guard let containerView = containerView else {
            return nil;
        }
                
        return containerView.getSubviewWithClass(name)
    }
    
}

extension NSView {
    
    func getSubviewWithClass(name: String) -> NSView? {
        if objc_getClass(name).self === self.dynamicType {
            return self
        }
        
        for subview in subviews {
            let viewWithSpecifiedClassName = subview.getSubviewWithClass(name)
            if let result = viewWithSpecifiedClassName {
                return result
            }
        }
        
        return nil
    }
    
    func getParentViewWithClass(names: [String]) -> NSView? {
        for name in names {
            if let classObject = objc_getClass(name) as? AnyClass {
                if self.dynamicType === classObject {
                    return self;
                }
            } else {
                continue
            }
        }
        
        return superview?.getParentViewWithClass(names)
    }
    
}

extension CGRect {
    
    func right() -> CGFloat {
        return left() + size.width;
    }
    
    func left() -> CGFloat {
        return origin.x;
    }
    
}
