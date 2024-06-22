import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:game_consign_assessment/core/database.dart';
import 'package:game_consign_assessment/core/styles.dart';
import 'package:game_consign_assessment/features/reminders/models/reminder.dart';
import 'package:game_consign_assessment/features/reminders/presentations/bloc/reminder_bloc/reminder_bloc.dart';
import 'package:game_consign_assessment/shared/widgets/custom_dropdown_widget.dart';
import 'package:game_consign_assessment/shared/widgets/datefield_widget.dart';
import 'package:game_consign_assessment/shared/widgets/textfield_widget.dart';
import 'package:game_consign_assessment/utils/custom_date.dart';
import 'package:game_consign_assessment/utils/loading_overlay.dart';
import 'package:intl/intl.dart';

class ReminderEdit extends StatefulWidget {
  final Reminder reminder;
  const ReminderEdit({super.key, required this.reminder});

  @override
  State<ReminderEdit> createState() => _ReminderEditState();
}

class _ReminderEditState extends State<ReminderEdit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isActive = true;
  DateTime? dateTime;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late ReminderBloc reminderBloc;
  String type = 'TIME';
  GeoPoint? geoPoint;

  void initData() {
    isActive = widget.reminder.isActive == 1;
    _titleController.text = widget.reminder.title ?? '';
    _descriptionController.text = widget.reminder.description ?? '';
    type = widget.reminder.type ?? 'TIME';
    dateTime = widget.reminder.time != null
        ? DateFormat("HH:mm").parse(widget.reminder.time!)
        : null;
    if (widget.reminder.latitude != null && widget.reminder.longitude != null) {
      geoPoint = GeoPoint(
          latitude: widget.reminder.latitude!,
          longitude: widget.reminder.longitude!);

      _locationController.text = "${geoPoint?.latitude},${geoPoint?.longitude}";
    }
  }

  @override
  void initState() {
    reminderBloc = BlocProvider.of<ReminderBloc>(context);
    initData();
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
            "Edit Reminder",
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
                CustomDropdown<String>(
                  label: 'Type',
                  initialValue: type,
                  data: const ["TIME", "LOCATION"],
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                type == 'TIME'
                    ? DateFieldWidget(
                        label: 'Time',
                        initialValue: dateTime,
                        required: true,
                        onChanged: (DateTime? value) {
                          dateTime = value;
                        },
                      )
                    : GestureDetector(
                        onTap: () async {
                          geoPoint = await showSimplePickerLocation(
                            context: context,
                            initPosition: widget.reminder.latitude != null
                                ? GeoPoint(
                                    latitude: widget.reminder.latitude!,
                                    longitude: widget.reminder.longitude!)
                                : null,
                            isDismissible: true,
                            title: "Pick Location",
                            textConfirmPicker: "pick",
                            // initCurrentUserPosition: UserTrackingOption(),
                          );

                          if (geoPoint != null) {
                            _locationController.text =
                                "${geoPoint?.latitude},${geoPoint?.longitude}";
                          }
                        },
                        child: TextFieldWidget(
                          label: 'Location',
                          enabled: false,
                          controller: _locationController,
                          required: true,
                        ),
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
            onPressed: updateReminder,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text('UPDATE REMINDER'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateReminder() async {
    if (!_form.currentState!.validate()) return;

    DatabaseInstance db = DatabaseInstance();
    reminderBloc.add(ReminderUpdate(
      params: {
        db.reminderId: widget.reminder.id!,
        db.reminderTitle: _titleController.text,
        db.reminderDescription: _descriptionController.text,
        db.reminderLatitude: geoPoint?.latitude ?? 0.0,
        db.reminderLongitude: geoPoint?.longitude ?? 0.0,
        db.reminderType: type,
        db.reminderIsActive: isActive ? 1 : 0,
        db.reminderTime:
            dateTime != null ? DateFormat.Hm().format(dateTime!) : null,
        db.reminderCreatedAt: CustomDate.timestamp(),
        db.reminderUpdatedAt: CustomDate.timestamp(),
      },
    ));
  }
}
