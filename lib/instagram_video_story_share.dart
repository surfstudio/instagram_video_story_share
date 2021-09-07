import 'dart:async';

import 'package:flutter/services.dart';

class InstagramVideoStoryShare {
  static const MethodChannel _channel =
      const MethodChannel('instagram_video_story_share');

  static Future<bool> get instagramInstalled async {
    bool isInstagramInstalled =
        await _channel.invokeMethod('isInstagramInstalled');
    return isInstagramInstalled;
  }

  static Future<bool> shareVideoToInstagramStories(
      {required String videoPath}) async {
    Map<dynamic, dynamic> sharedMap =
        await _channel.invokeMethod('shareVideoToInstagramStories', videoPath);
    bool isShared = sharedMap["result"] as bool;
    return isShared;
  }

  static Future<bool> shareVideoToInstagram({required String videoPath}) async {
    Map<dynamic, dynamic> sharedMap =
        await _channel.invokeMethod('shareVideoToInstagramStories', videoPath);
    bool isShared = sharedMap["result"] as bool;
    return isShared;
  }
}
