import Cocoa
import FlutterMacOS

class MainFlutterWindowController: NSWindowController {
    convenience init() {
        self.init(windowNibName:"MainMenu")
    }
}

class MainFlutterWindow: NSWindow {
    static var flutterViewController: FlutterViewController? = nil
  
    convenience init() {
        let viewController = MainFlutterWindowController()
        self.init(contentViewController: viewController as! NSViewController)
    }
    
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    self.contentViewController = flutterViewController
      
    self.setFrame(NSRect(x:0,y:0,width: 1366/2.5,height: 768/2), display: false);
    self.center();

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
      
    let controller : FlutterViewController = self.contentViewController as! FlutterViewController
    let comChannel = FlutterMethodChannel(name: "macos-communication-channel",binaryMessenger: controller.engine.binaryMessenger)
        comChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "openNotificationWindow":
                Utils.openNotificationWindow()
            case "runWithArgs":
                if let arguments = call.arguments as? Dictionary<String,String>,
                   let msg = arguments["msg"],
                   let interval = arguments["interval"]{
                    NSLog("arguments passed :\(arguments)");
                    Utils.RunInBackGround(msg: msg, TimeInMinutes: interval)
                    
                } else {
                    return
                }
            default:
                NSLog("default case :(")
            }
             
        })
    }
    
    func show() {
        self.display()
    }
    
}
