import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:linker/linker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class Button extends StatelessWidget {
  final String label;

  final VoidCallback onPressed;

  Button({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
        onPressed: onPressed,
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: new Text(label));
  }
}

class AndroidExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Button(
              onPressed: () async {
                try {
                  ActivityResult result = await Linker.startActivityForResult(
                      new Intent.fromAction("android.settings.SETTINGS"), 0);
                  print(result);
                } on PlatformException catch (e) {
                  print("Open failed $e");
                }
              },
              label: "Open Settings"),
          new Button(
              onPressed: () async {
                try {
                  await Linker.startActivity(new Intent.fromAction(
                    "android.intent.action.VIEW",
                    uri: Uri.parse(
                        "http://ditu.google.cn/maps?hl=zh&mrt=loc&q=31.1198723,121.1099877(上海青浦大街100号)"),
                  ));
                } on PlatformException catch (e) {
                  print("Open failed $e");
                }
              },
              label: "Open google map"),
        ],
      ),
    );
  }
}

class IosExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          new Button(
              onPressed: () async {
                try {
                 await Linker.openURL("weixin://");
                } on PlatformException catch (e) {
                  print("Open failed $e");
                }
              },
              label: "Open Wechat"),

          new Button(
              onPressed: () async {
                try {
                  await Linker.openURL("App-Prefs:root");
                } on PlatformException catch (e) {
                  print("Open failed $e");
                }
              },
              label: "Open Settings"),


          new Button(
              onPressed: () async {
                try {
                  await Linker.openURL("tel:10086");
                } on PlatformException catch (e) {
                  print("Open failed $e");
                }
              },
              label: "Call 10086"),


        ],
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Platform.isAndroid ? new AndroidExample() : new IosExample(),
      ),
    );
  }
}
