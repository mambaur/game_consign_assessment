import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_consign_assessment/core/local_notification.dart';
import 'package:game_consign_assessment/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? data = 0;

  getData() async {
    String prefKey = 'test_data';
    final prefs = await SharedPreferences.getInstance();
    int? testData = prefs.getInt(prefKey);
    print('Test data: $testData');
    if (mounted) {
      setState(() {
        data = testData;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test Data',
            ),
            Text(
              data.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => getData(),
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              localNotification.show(
                Random().nextInt(10000),
                'Notifikasi Alert Masuk',
                "Ini Notifikasi",
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel?.id ?? '',
                    channel?.name ?? '',
                    channelDescription: channel?.description ?? '',
                    playSound: true,
                    // color: Colors.white,
                    // icon: notificationIcon,
                  ),
                ),
                // payload: payload
              );
            },
            tooltip: 'Notification',
            child: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('test_data');

              Workmanager().cancelByUniqueName("task-identifier2");
            },
            tooltip: 'Remove',
            child: const Icon(Icons.delete_outline),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('test_data');

              Workmanager().cancelAll();
            },
            tooltip: 'Remove All',
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            onPressed: () async {
              Workmanager().registerOneOffTask(
                "task-one-time",
                "taskOneTime",
                initialDelay: const Duration(seconds: 10),
              );
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
