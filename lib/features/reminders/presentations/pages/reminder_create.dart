import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_consign_assessment/core/database.dart';
import 'package:game_consign_assessment/core/styles.dart';
import 'package:game_consign_assessment/features/reminders/presentations/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:game_consign_assessment/shared/widgets/datefield_widget.dart';
import 'package:game_consign_assessment/shared/widgets/textfield_widget.dart';
import 'package:game_consign_assessment/utils/custom_date.dart';
import 'package:game_consign_assessment/utils/loading_overlay.dart';
import 'package:intl/intl.dart';

class ReminderCreate extends StatefulWidget {
  const ReminderCreate({super.key});

  @override
  State<ReminderCreate> createState() => _ReminderCreateState();
}

class _ReminderCreateState extends State<ReminderCreate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isActive = true;
  DateTime? dateTime;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late ReminderBloc reminderBloc;

  @override
  void initState() {
    reminderBloc = BlocProvider.of<ReminderBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (state is ReminderLoadInProgress) {
          LoadingOverlay.show(context);
        } else if (state is ReminderLoadSuccess) {
          LoadingOverlay.hide();
          Navigator.pop(context);
        } else if (state is ReminderLoadFailure) {
          LoadingOverlay.hide();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.accent,
          foregroundColor: AppColor.light,
          // centerTitle: true,
          title: const Text(
            "Create Reminder",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColor.accent,
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  label: 'Title',
                  controller: _titleController,
                  required: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                DateFieldWidget(
                  label: 'Time',
                  required: true,
                  onChanged: (DateTime? value) {
                    dateTime = value;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: const Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    )),
                CheckboxListTile(
                    value: isActive,
                    contentPadding: EdgeInsets.zero,
                    checkColor: AppColor.accent,
                    fillColor: WidgetStateProperty.all(AppColor.light),
                    side: const BorderSide(width: 2, color: AppColor.light),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'Active',
                      style: TextStyle(color: AppColor.light),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isActive = value!;
                      });
                    }),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                  label: 'Description',
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 10,
                  required: true,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.accent,
                backgroundColor: AppColor.light,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: storeReminder,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('CREATE REMINDER'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> storeReminder() async {
    if (!_form.currentState!.validate()) return;

    DatabaseInstance db = DatabaseInstance();
    reminderBloc.add(ReminderStore(
      params: {
        db.reminderTitle: _titleController.text,
        db.reminderDescription: _descriptionController.text,
        db.reminderIsActive: isActive ? 1 : 0,
        db.reminderTime: DateFormat.Hm().format(dateTime!),
        db.reminderCreatedAt: CustomDate.timestamp(),
        db.reminderUpdatedAt: CustomDate.timestamp(),
      },
    ));
  }
}
