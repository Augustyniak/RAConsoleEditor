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

var sharedPlugin: RAConsoleEditor?

class RAConsoleEditor: NSObject {
    
    var bundle: NSBundle
    var actionsController: ActionsController?
    
    init(bundle: NSBundle) {
        self.bundle = bundle
        
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("controlGroupDidChange"), name: "IDEControlGroupDidChangeNotificationName", object: nil);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func controlGroupDidChange() {
        setUp();
    }
    
    func setUp() {
        let consoleViewInterface = ConsoleViewInterface()
        guard let consoleScopeBarInterface = consoleViewInterface.consoleScopeBarInterface where consoleViewInterface.consoleTextView != nil else  {
            consoleLogsMenuItem()?.enabled = false;
            return
        }
        if actionsController == nil {
            actionsController = ActionsController(fileController: FileController(), textInput: consoleViewInterface, settingsStorage: SettingsStorage(), fileOpener: FileOpener())
        }
        
        guard let buttonActionsController = self.actionsController else { return }
        
        setUpMenuItemsIfNotExist(withActionsController: buttonActionsController)
        setupScopeBarButtonIfNotExist(withActionsController: buttonActionsController, consoleScopeBarInterface: consoleScopeBarInterface)
        consoleLogsMenuItem()?.enabled = true
    }
    
}


extension RAConsoleEditor {
    
    func setupScopeBarButtonIfNotExist(withActionsController actionsController: ActionsController, consoleScopeBarInterface: ScopeBarInterface) {
        guard consoleScopeBarInterface.scopeBarView.subviews.filter( { return $0 as? ContainerView != nil} ).count == 0 else {
            return
        }
        
        guard let referenceView = consoleScopeBarInterface.getViewWhichShouldBeLeftNeighbourOfOpenInEditorButton() else {
            return
        }
        
        let openButton = createButtonWithTitle(
            NSLocalizedString("Open", comment: ""),
            alternateTitle: NSLocalizedString("Choose editor", comment: ""),
            target: actionsController,
            action: "saveAndOpenFileWithTextEditor",
            alternateAction:  "chooseDefaultTextEditor")
        let saveButton = createButtonWithTitle(
            NSLocalizedString("Save", comment: ""),
            alternateTitle: NSLocalizedString("Save as", comment: ""),
            target: actionsController,
            action: "saveFile",
            alternateAction: "saveFileAs")
        let exploreButton = createButtonWithTitle(
            NSLocalizedString("Explore", comment: ""),
            alternateTitle: NSLocalizedString("Choose default location", comment: ""),
            target: actionsController,
            action: "explore",
            alternateAction: "chooseDefaultDestinationPath")
        
        let scopeBarView = consoleScopeBarInterface.scopeBarView
        let containerView = ContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.setContentCompressionResistancePriority(NSLayoutPriorityRequired, forOrientation: NSLayoutConstraintOrientation.Horizontal)
        containerView.containedViews = [openButton, saveButton, exploreButton]
        scopeBarView.addSubview(containerView)
        
        let leftConstraint = NSLayoutConstraint.init(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        scopeBarView.addConstraint(leftConstraint)
        let heightConstraint = NSLayoutConstraint.init(item: containerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scopeBarView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        scopeBarView.addConstraint(heightConstraint)
        let centerConstraint = NSLayoutConstraint.init(item: containerView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scopeBarView, attribute:NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        scopeBarView.addConstraint(centerConstraint)
    }
    
    func createButtonWithTitle(title: String, alternateTitle: String? = nil, target: AnyObject, action: String, alternateAction: String? = nil) -> NSButton {
        let alternateActionSelector = alternateAction != nil ? Selector(alternateAction!) : nil
        let button = RAButton(frame: CGRectMake(0, 0 , 100, 30), defaultTitle: title, alternateTitle: alternateTitle, defaultAction: Selector(action), alternateAction: alternateActionSelector)
        button.title = title
        if let alternateTitle = alternateTitle {
            button.alternateTitle = alternateTitle
        } else {
            button.alternateTitle = title;
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.action = Selector(action)
        button.target = target
        button.bezelStyle = NSBezelStyle.RegularSquareBezelStyle
        return button
    }
}


extension RAConsoleEditor {
    
    func setUpMenuItemsIfNotExist(withActionsController actionController: ActionsController) {
        guard let item = NSApp.mainMenu!.itemWithTitle("Edit") where consoleLogsMenuItem() == nil else { return }
        
        let consoleActionsSubmenu = NSMenu(title: "")
        consoleActionsSubmenu.autoenablesItems = false
        
        let consoleActionsMenuItem = NSMenuItem(title:consoleLogsMenuItemTitle(), action:nil, keyEquivalent:"")
        consoleActionsMenuItem.submenu = consoleActionsSubmenu
        consoleActionsMenuItem.enabled = true
        
        let openAction = createMenuItem(withTitle: NSLocalizedString("Open", comment: ""), action: "saveAndOpenFileWithTextEditor", keyEquivalent:"o")
        openAction.target = actionsController
        openAction.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue | NSEventModifierFlags.CommandKeyMask.rawValue)
        
        let saveAction = createMenuItem(withTitle: NSLocalizedString("Save", comment: ""), action: "saveFile", keyEquivalent: "s")
        saveAction.target = actionsController
        saveAction.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue | NSEventModifierFlags.CommandKeyMask.rawValue)
        
        let saveAsAction = createMenuItem(withTitle: NSLocalizedString("Save As...", comment: ""), action: "saveFileAs", keyEquivalent: "s")
        saveAsAction.target = actionsController
        saveAsAction.alternate = true
        saveAsAction.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue | NSEventModifierFlags.CommandKeyMask.rawValue | NSEventModifierFlags.AlternateKeyMask.rawValue)
        
        let openDirectoryAction = createMenuItem(withTitle: NSLocalizedString("Explore", comment: ""), action: "explore", keyEquivalent: "d")
        openDirectoryAction.target = actionsController
        openDirectoryAction.keyEquivalentModifierMask = Int(NSEventModifierFlags.ControlKeyMask.rawValue | NSEventModifierFlags.CommandKeyMask.rawValue)
        
        consoleActionsSubmenu.addItem(openAction)
        consoleActionsSubmenu.addItem(saveAction)
        consoleActionsSubmenu.addItem(saveAsAction)
        consoleActionsSubmenu.addItem(openDirectoryAction)
        
        item.submenu!.addItem(NSMenuItem.separatorItem())
        item.submenu!.addItem(consoleActionsMenuItem)
    }
    
    func consoleLogsMenuItemTitle() -> String {
        return NSLocalizedString("Console Logs", comment: "")
    }
    
    func consoleLogsMenuItem() -> NSMenuItem? {
        guard let item = NSApp.mainMenu!.itemWithTitle("Edit") else {
            return nil
        }
        
        return item.submenu!.itemArray.filter({ $0.title == consoleLogsMenuItemTitle() }).first
    }
    
    func createMenuItem(withTitle title: String, action: Selector, keyEquivalent: String) -> NSMenuItem {
        let menuItem = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        menuItem.enabled = true
        return menuItem
    }
    
}
