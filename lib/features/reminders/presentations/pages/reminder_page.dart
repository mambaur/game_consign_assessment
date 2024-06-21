import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_consign_assessment/core/local_notification.dart';
import 'package:game_consign_assessment/features/reminders/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:game_consign_assessment/features/reminders/models/reminder.dart';
import 'package:game_consign_assessment/features/reminders/usecases/get_reminders/get_reminders.dart';
import 'package:game_consign_assessment/main.dart';
import 'package:game_consign_assessment/utils/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:simple_infinite_scroll/simple_infinite_scroll.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final SimpleInfiniteScrollController _controller =
      SimpleInfiniteScrollController();
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
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (state is ReminderLoadSuccess) {
          _controller.refresh();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Reminder App"),
        ),
        body: SimpleInfiniteScroll<Reminder>(
          controller: _controller,
          fetch: fetchReminders,
          initialPage: 15,
          itemBuilder: (context, index, item) {
            return Card(
              child: ListTile(
                title: Text(item.title ?? ''),
                subtitle: Text(item.description ?? ''),
              ),
            );
          },
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
      ),
    );
  }

  Future<List<Reminder>?> fetchReminders(page, limit) async {
    GetReminders getReminders = GetReminders();
    return getReminders(GetReminderParams(page: page, limit: limit))
        .then((result) {
      if (result.isSuccess) {
        return result.resultValue ?? [];
      } else {
        CustomToast.warning(context, description: result.errorMessage);
        return null;
      }
    });
  }
}
