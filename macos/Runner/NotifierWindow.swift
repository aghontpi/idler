//
//  NotifierWindow.swift
//  Runner

import Cocoa

class NotifierWindow : NSWindowController {
    
    var title = "dep"
    
    
    func setTitle(params: String) {
        self.title = params
    }
    
    convenience init() {
        self.init(windowNibName:"Notifier")
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        print("window title ", displayName)
        return self.title
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = self.title
        NSLog("screen title :\(self.title)")
        self.window?.contentView?.setValue(self.title, forKey: "notifier_label")
        self.window?.orderFrontRegardless()
        let _s = NSScreen.main
        NSLog("Screen size :\(String(describing: _s?.frame.width))")
        let screenWidth = _s?.frame.width
        if screenWidth != nil {
            self.window?.setFrameOrigin(NSPoint(x: screenWidth ?? 1095,y:0))
        }
        
    }
    
}
    
