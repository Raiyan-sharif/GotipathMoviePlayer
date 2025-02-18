import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private lazy var videoPlayer = VideoPlayerViewController()
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "video_player_channel",
      binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }
      
      if call.method == "togglePlayPause" {
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String,
              let isPlaying = args["isPlaying"] as? Bool else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Invalid arguments",
                            details: nil))
          return
        }
        
        let newState = self.videoPlayer.togglePlayPause(url: url, isPlaying: isPlaying)
        result(newState)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
