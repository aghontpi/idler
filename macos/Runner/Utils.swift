import Foundation


class Utils {
    
    static func openNotificationWindow() {
        let notifierWindowController = NotifierWindow()
        notifierWindowController.setTitle(params: "Drink Water!!")
        notifierWindowController.showWindow(nil)
    }
    
    static func RunInBackGround(msg : String, TimeInMinutes: String) {
        // parse the string timer 
        // setup timer
        // call opennotificaton window
        NSLog("run in background ::")
        let timeinSeconds = (Int(TimeInMinutes) ?? 15) * 60
        if #available(macOS 10.12, *) {
            NSLog("configured to run every \(timeinSeconds)  seconds")
            Timer.scheduledTimer(withTimeInterval: Double(timeinSeconds) , repeats: true, block:  {_ in
                NSLog("timer tick")
                openNotificationWindow()
            })
        } else {
            NSLog("macos version not supported")
        }
    }
}
