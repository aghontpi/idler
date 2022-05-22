import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class IdleNotifierForm extends StatefulWidget {
  const IdleNotifierForm({super.key});

  @override
  IdleNotifierFormState createState() {
    return IdleNotifierFormState();
  }
}

class IdleNotifierFormState extends State<IdleNotifierForm> {
  final _formKey = GlobalKey<FormState>();
  static const forMacOsPlatform = MethodChannel("macos-communication-channel");
  static const forAndroidPlatform =
      MethodChannel("android-communication-channel");
  String msg = "";
  int interval = Platform.isAndroid ? 60 : 1;

  static const androidSpecifics = AndroidNotificationDetails(
      "99", "Notification Remainder Channel",
      channelDescription: "app gives you notification at configured intervals",
      importance: Importance.max,
      priority: Priority.high,
      icon: "notification_icon",
      ticker: "ticker");

  static const platformDetails =  NotificationDetails(android: androidSpecifics);

  onSubmitPressed() async {
    log("$msg $interval");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text("Config set!"))),
      );
      if (Platform.isMacOS) {
        log("invoking macos native code");
        forMacOsPlatform
            .invokeMethod("runWithArgs", {"msg": msg, "interval": interval});
      } else if (Platform.isAndroid) {
        log("android notification set");
        await flutterLocalNotificationsPlugin.periodicallyShow(88,'♡ idle notifier ♡', msg, RepeatInterval.hourly, platformDetails);
      }

    }
  }

  onPreviewPressed() async {
    if (Platform.isMacOS) {
      log("macos native call");
      try {
        forMacOsPlatform.invokeMethod("openNotificationWindow");
      } catch (e) {
        log("unable to call macos specific native function");
      }
    } else if (Platform.isAndroid) {
      log("android.. launch notification here");
      if (_formKey.currentState!.validate()){
        _formKey.currentState!.save();
        log("launching notifications");
        await flutterLocalNotificationsPlugin.show(88,'♡ idle notifier ♡', msg, platformDetails, payload: 'dummy');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  onSaved: ((newValue) => msg = newValue as String),
                  decoration:
                      const InputDecoration(hintText: 'Enter custom message'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a msg';
                    }
                    return null;
                  },
                ),
                // const SizedBox(height: 8.0),
                // TextFormField(
                //   onSaved: (newValue) => interval = int.parse(newValue!),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //   decoration: const InputDecoration(hintText: 'Enter interval'),
                // ),
                // ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text(Platform.isAndroid? "android & IOS flutter limitations, \nCan only be 60 min" :'Notify every $interval minutes',softWrap: true, textAlign: TextAlign.center))
                  ],
                ),
                const SizedBox(height: 16),
                Slider(
                    value: Platform.isAndroid ? 60: interval.toDouble(),
                    max: 60,
                    divisions: 60,
                    label: interval.toString(),
                    onChanged: Platform.isAndroid ? null : (double value) {
                      setState(() {
                        print("change -> $value");
                        interval = value.toInt();
                      });
                    }),
                const SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: onSubmitPressed,
                          child: const Text('Submit')),
                      const SizedBox(width: 24.0),
                      ElevatedButton(
                          onPressed: onPreviewPressed,
                          child: const Text('Preview'))
                    ])
              ],
            )));
  }
}
