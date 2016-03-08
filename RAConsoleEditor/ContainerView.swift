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

class ContainerView : NSView {
    
    var containedViews: [NSView]  {
        get {
            return self.subviews
        }
        
        set {
            for view in subviews {
                view.removeFromSuperview()
            }
            
            guard newValue.count > 0 else {
                return
            }
            
            for view in newValue {
                addSubview(view)
            }
            
            for (index, view) in newValue.enumerate() {
                let firstView = index == 0
                let previousView = firstView ? self : newValue[index-1]
                let lastView = index == (newValue.count - 1)
                let nextView = lastView ? self : newValue[index+1]
                
                let leftConstraint = NSLayoutConstraint.init(item: view, attribute: .Leading, relatedBy: .Equal, toItem: previousView, attribute: firstView ? .Leading : .Trailing, multiplier: 1, constant: 0)
                self.addConstraint(leftConstraint)
                let heightConstraint = NSLayoutConstraint.init(item: view, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: -6)
                self.addConstraint(heightConstraint)
                let centerConstraint = NSLayoutConstraint.init(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
                self.addConstraint(centerConstraint)
                let rightConstraint = NSLayoutConstraint.init(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: nextView, attribute: lastView ? .Trailing : .Leading, multiplier: 1, constant: 0)
                self.addConstraint(rightConstraint)
            }
            
        }
    }
    
}
