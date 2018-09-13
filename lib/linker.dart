import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

@immutable
class Intent {


  static const String ACTION_WIRELESS_SETTINGS="android.settings.WIRELESS_SETTINGS";
  static const String ACTION_SETTINGS="android.settings.SETTINGS";



  final String className;
  final String packageName;
  final String action;
  final Uri uri;
  final Map<String, dynamic> extras;

  Intent._(
      {this.className, this.action, this.packageName, this.uri, this.extras});

  factory Intent.fromAction(String action,
      {Uri uri, String packageName, String className}) {
    return new Intent._(
        action: action,
        uri: uri,
        className: className,
        packageName: packageName);
  }

  factory Intent.callApp(
      {String className, String packageName, Map<String, dynamic> extras}) {
    return new Intent._(
        packageName: packageName, className: className, extras: extras);
  }

  Map toMap() {
    return {
      "className": className,
      "packageName": packageName,
      "extras": extras,
      "action": action,
      "uri": uri?.toString(),
    };
  }
}

class ActivityResult {
  static const int RESULT_CANCELED = 0;
  static const int RESULT_FIRST_USER = 1;
  static const int RESULT_OK = -1;

  ///
  final int resultCode;

  ///
  final int requestCode;

  ///
  final Intent intent;

  bool get isOk {
    return resultCode == RESULT_OK;
  }

  bool get isCancel {
    return resultCode == RESULT_CANCELED;
  }

  ActivityResult._({this.requestCode, this.resultCode, this.intent});

  factory ActivityResult.fromMap(dynamic map) {
    dynamic _intent = map['intent'];
    Intent intent;
    if (_intent != null) {
      intent = new Intent._(
        action: _intent['action'],
      );
    }
    return new ActivityResult._(
        requestCode: map['requestCode'],
        resultCode: map['resultCode'],
        intent: intent);
  }

  @override
  String toString() {
    return "ActivityResult {requestCode:$requestCode,resultCode:$resultCode,intent:$intent}";
  }
}

class Linker {
  static const MethodChannel _channel = const MethodChannel('linker');

  /// IOS only
  static Future<bool> canOpenURL(String url) async {
    if (!Platform.isIOS)
      throw new Exception("This method must be called in ios");
    dynamic value = await _channel.invokeMethod("canOpenURL", url);
    return value as bool;
  }

  /// IOS only,
  static Future<bool> openURL(String url) async {
    if (!Platform.isIOS)
      throw new Exception("This method must be called in ios");
    dynamic value = await _channel.invokeMethod("openURL", url);
    return value as bool;
  }

  /// android only
  static Future<ActivityResult> startActivityForResult(
      Intent intent, int requestCode) async {
    if (!Platform.isAndroid)
      throw new Exception("This method must be called in android");
    Map data = intent.toMap();
    data['requestCode'] = requestCode;
    dynamic value = await _channel.invokeMethod("startActivityForResult", data);
    return new ActivityResult.fromMap(value);
  }

  /// android only
  static Future<bool> startActivity(Intent intent) async {
    if (!Platform.isAndroid)
      throw new Exception("This method must be called in android");
    dynamic value =
        await _channel.invokeMethod("startActivity", intent.toMap());
    return value as bool;
  }

  static Future<bool> openSetting() async{
    if(Platform.isAndroid){
      return startActivity(new Intent.fromAction(Intent.ACTION_SETTINGS));
    }else{
      var value = await _channel.invokeMethod("openSetting");
      return value as bool;
    }
  }
  static Future<bool> openNetworkSetting() async{
    if(Platform.isAndroid){
      return startActivity(new Intent.fromAction(Intent.ACTION_WIRELESS_SETTINGS));
    }else{
      var value = await _channel.invokeMethod("openSetting");
      return value as bool;
    }
  }
}
