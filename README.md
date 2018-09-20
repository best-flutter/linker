


# linker

A flutter plugin to link with other app or system function.

## Getting Started

add 

```

linker: 0.0.2

```
to your pubspec.yaml, and run `flutter packages get`


## Usage

### Android


Use action

```
try {
  ActivityResult result = await Linker.startActivityForResult(
      new Intent.fromAction("android.settings.SETTINGS"), 0);
  print(result);
} on PlatformException catch (e) {
  print("Open failed $e");
}

```

Open google map

```
try {
  await Linker.startActivity(new Intent.fromAction(
    "android.intent.action.VIEW",
    uri: Uri.parse(
        "http://ditu.google.cn/maps?hl=zh&mrt=loc&q=31.1198723,121.1099877(上海青浦大街100号)"),
  ));
} on PlatformException catch (e) {
  print("Open failed $e");
}

```

### ios


Open wechat

```
 try {
 await Linker.openURL("weixin://");
} on PlatformException catch (e) {
  print("Open failed $e");
}
```


Open Settings
```
try {
  await Linker.openURL("App-Prefs:root");
} on PlatformException catch (e) {
  print("Open failed $e");
}

```

Call 10086

```
 try {
  await Linker.openURL("tel:10086");
} on PlatformException catch (e) {
  print("Open failed $e");
}
```









