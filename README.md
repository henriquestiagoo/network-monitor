# NetworkMonitor

A solution that monitors and reacts to network connectivity changes 🌦️.

## Requirements

- iOS 12 and later
- macOS 10.14 and later

## Install

Add `https://github.com/henriquestiagoo/network-monitor` in the [“Swift Package Manager” tab in Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Usage

You can initiate the monitoring process by making a call to NetworkMonitor.shared.startMonitoring() from any location within your code. However, in most cases, it is a good idea to initiate this process in the AppDelegate.

```swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
    
        // start monitoring network changes
        NetworkMonitor.shared.startMonitoring()

        return true
  }
}
```

After that, you can use NetworkMonitor.shared.isConnected to check the real-time status of you network connection.

```swift
import NetworkMonitor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(connectivityStatusChanged(notification:)), 
            name: Notification.Name.connectivityStatusChanged, 
            object: nil
        )
    }

    @objc func connectivityStatusChanged(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            print("Connected")
        } else {
            print("Not connected")
        }
    }
}
```

> A DispatchQueue is being used to manage the network changes, so don't forget to switch to the Main Thread if you want to update the UI.


## Note

You may find unexpected results using the simulator. I recommend, if possible, to test in a real device.
 

## Reporting Issues and Contributing

If you encounter any issues or have suggestions for improvements, I encourage you to [submit an issue](https://github.com/henriquestiagoo/network-monitor/issues/new) on GitHub. Any feedback or contribution to help make this application better are welcome 🙂.