import Flutter
import UIKit

public class SwiftInstagramVideoStorySharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "instagram_video_story_share", binaryMessenger: registrar.messenger())
    let instance = SwiftInstagramVideoStorySharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let prefix: String = "instagramVideoShare: "

    switch call.method {
        case "shareVideoToInstagramStories", "shareVideoToInstagram":
            var resultDictionary: [String: Any] = [:]
            resultDictionary["result"] = false
            resultDictionary["message"] = "Message From Swift: ___"
            guard let args = call.arguments else {
                print(prefix + "Unexpected error ARGS HAVE A PROBLEM.")
                resultDictionary["result"] = false
                resultDictionary["message"] = "Message From Swift error ARGS HAVE A PROBLEM"
                result(resultDictionary)
                return
            }
            let videoPath = args as? String
            print(prefix + "videoPath - \(videoPath ?? "unknown")")
            let instagramUrl = URL(string: "instagram://app")
            if UIApplication.shared.canOpenURL(instagramUrl!) {
                print(prefix + "Instagram is installed")
                let documentExists = FileManager.default.fileExists(atPath: videoPath!)
                print(prefix + "documentExists - \(documentExists)")
                if(documentExists) {
                    do {
                        let video = try NSData(contentsOfFile: videoPath!, options: .mappedIfSafe)
                        var pasterboardItems:[[String:Any]]? = nil
                        pasterboardItems = [["com.instagram.sharedSticker.backgroundVideo": video as Any]]
                        UIPasteboard.general.setItems(pasterboardItems!)
                        var url: URL?
                        switch call.method {
                            case "shareVideoToInstagramStories" :
                                url = URL(string: "instagram-stories://share")
                            case "shareVideoToInstagram" :
                                url = URL(string: "instagram://library?LocalIdentifier=" + videoPath!)
                            default :
                                result(FlutterMethodNotImplemented)
                        }
                        UIApplication.shared.open(url!)
                        resultDictionary["result"] = true
                        resultDictionary["message"] = "Message From Swift \(videoPath ?? "unknown")"
                    } catch {
                        print(prefix + "Unexpected error converting to NSDATA - \(error).")
                        resultDictionary["result"] = false
                        resultDictionary["message"] = "Message From Swift error converting to NSDATA"
                    }
                } else {
                    print(prefix + "Unexpected error DOCUMENT DOES NOT EXIST.")
                    resultDictionary["result"] = false
                    resultDictionary["message"] = "Message From Swift error DOCUMENT DOES NOT EXIST"
                }
            } else {
                print(prefix + "Instagram is not installed")
                resultDictionary["result"] = false
                resultDictionary["message"] = "Message From Swift INSTAGRAM NOT INSTALLED"
            }
            print(prefix + "resultDictionary - \(resultDictionary)")
            result(resultDictionary)
        case "isInstagramInstalled" :
            let instagramUrl = URL(string: "instagram-stories://share")
            if UIApplication.shared.canOpenURL(instagramUrl!) {
                result(true)
            } else {
                result(false)
            }
        default :
            result(FlutterMethodNotImplemented)
    }
  }
}