import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_consign_assessment/core/styles.dart';
import 'package:game_consign_assessment/features/reminders/presentations/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:game_consign_assessment/features/reminders/models/reminder.dart';
import 'package:game_consign_assessment/features/reminders/presentations/pages/reminder_create.dart';
import 'package:game_consign_assessment/features/reminders/presentations/pages/reminder_edit.dart';
import 'package:game_consign_assessment/features/reminders/usecases/get_reminders/get_reminders.dart';
import 'package:game_consign_assessment/shared/widgets/empty_widget.dart';
import 'package:game_consign_assessment/utils/custom_toast.dart';
import 'package:game_consign_assessment/utils/simple_alert.dart';
import 'package:simple_infinite_scroll/simple_infinite_scroll.dart';
import '../../../../core/local_notification.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late ReminderBloc reminderBloc;
  final SimpleInfiniteScrollController _controller =
      SimpleInfiniteScrollController();

  @override
  void initState() {
    reminderBloc = BlocProvider.of<ReminderBloc>(context);
    super.initState();
    handleRouteNotification();
  }

  handleRouteNotification() {
    onClickNotification.stream.listen((payload) {
      Map<String, dynamic> data = json.decode(payload);
      Navigator.push(context, MaterialPageRoute(builder: (builder) {
        return ReminderEdit(reminder: Reminder.fromJson(data));
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (state is ReminderLoadSuccess) {
          CustomToast.success(context, description: state.message);
          _controller.refresh();
        } else if (state is ReminderLoadFailure) {
          CustomToast.error(context, description: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.accent,
          foregroundColor: AppColor.light,
          // centerTitle: true,
          title: const Text(
            "Reminder",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () => SimpleAlert.show(context,
                    showCancelButton: false,
                    title: "Information",
                    description:
                        "Please enable notification permission, location permissions and disable battery optimization, do you understand?"),
                icon: const Icon(Icons.info_outline)),
            IconButton(
                onPressed: () => SimpleAlert.show(
                      context,
                      title: "Are you sure want to delete all reminders?",
                      onYes: () {
                        reminderBloc.add(ReminderDeleteAll());
                      },
                    ),
                icon: const Icon(Icons.auto_delete_outlined))
          ],
        ),
        body: SimpleInfiniteScroll<Reminder>(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          controller: _controller,
          fetch: fetchReminders,
          emptyWidget: const Padding(
            padding: EdgeInsets.all(15.0),
            child: SizedBox(
              height: 50,
              child: EmptyWidget(
                title: 'Your reminder still empty',
              ),
            ),
          ),
          itemBuilder: (context, index, item) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return ReminderEdit(reminder: item);
                }));
              },
              child: Container(
                height: 118,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColor.accent),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.alarm, size: 30, color: Colors.white),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              item.description ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                    side:
                                        const BorderSide(color: AppColor.light),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () => SimpleAlert.show(
                                    context,
                                    title:
                                        "Are you sure want to delete ${item.title}",
                                    onYes: () {
                                      reminderBloc.add(
                                          ReminderDelete(params: item.id!));
                                    },
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppColor.light),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    item.isActive != 1 ? 'Inactive' : '',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.type == 'LOCATION'
                                      ? 'Location'
                                      : (item.time ?? ''),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "refresh-button",
              backgroundColor: AppColor.accent,
              foregroundColor: AppColor.light,
              onPressed: () async {
                _controller.refresh();
              },
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(
              height: 15,
            ),
            FloatingActionButton(
              heroTag: "add-button",
              backgroundColor: AppColor.accent,
              foregroundColor: AppColor.light,
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return const ReminderCreate();
                }));
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
