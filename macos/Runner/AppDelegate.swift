import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        if let statusButton = statusBarItem.button {
//          statusButton.image = NSImage(named: NSImage.Name("AppIcon"))
            statusButton.title = "idler ♡"
            statusButton.action = #selector(launchFromTray)
        }
        
        constructMenu()
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Show", action: #selector(launchFromTray), keyEquivalent: "w"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusBarItem.menu = menu
    }
    
    
    @objc func launchFromTray() {
        print("launch from tray")
        mainFlutterWindow.display()
        MainFlutterWindowController().showWindow(nil)
    }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
    
}
