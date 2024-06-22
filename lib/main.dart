import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_consign_assessment/features/reminders/presentations/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:math';
import 'package:game_consign_assessment/core/local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'app.dart';

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local Notification Configuration
  await localNotification.init();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(BlocProvider(
    create: (context) => ReminderBloc(),
    child: const App(),
  ));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    LocalNotification localNotification = LocalNotification();
    await localNotification.init();
    localNotification.show(
        Random().nextInt(10000),
        inputData?['title'],
        inputData?['description'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel?.id ?? '',
            channel?.name ?? '',
            channelDescription: channel?.description ?? '',
            playSound: true,
          ),
        ),
        payload: json.encode(inputData));

    return Future.value(true);
  });
}
