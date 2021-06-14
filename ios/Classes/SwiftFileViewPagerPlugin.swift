import Flutter
import UIKit

public class SwiftFileViewPagerPlugin: NSObject, FlutterPlugin {
    var downloadManger = DownloadManager()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "file_view_pager", binaryMessenger: registrar.messenger())
    let instance = SwiftFileViewPagerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "downloadFile" else {
        result(FlutterMethodNotImplemented)
        return
    }
    if let args = call.arguments as? Dictionary<String, Any> {
        if let urlString = args["url"] as? String {
            downloadManger.downloadFile(url: urlString) {
                resultSave in result(resultSave)
            }
        }
    }
  }
}
