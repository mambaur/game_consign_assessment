import 'package:game_consign_assessment/core/constant.dart';
import 'package:game_consign_assessment/core/database.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/result.dart';
import '../../../shared/models/response.dart';
import '../models/reminder.dart';
import '../usecases/get_reminders/get_reminders.dart';

class ReminderRepository {
  final dbInstance = DatabaseInstance();

  Future<Result<List<Reminder>>> getReminders(GetReminderParams params) async {
    try {
      // Setup pagination
      int offset = (params.limit * params.page) - params.limit;

      Database db = await dbInstance.database;
      final data = await db.rawQuery(
          'SELECT ${dbInstance.reminderTable}.*  FROM ${dbInstance.reminderTable} ORDER BY ${dbInstance.reminderTable}.${dbInstance.reminderCreatedAt} DESC LIMIT ${params.limit} OFFSET $offset',
          []);

      List<Reminder> reminders = [];
      if (data.isNotEmpty) {
        for (var i = 0; i < data.length; i++) {
          Reminder businessModel = Reminder(
            id: int.parse(data[i]['id'].toString()),
            title: data[i]['title'] == null || data[i]['title'] == ''
                ? null
                : data[i]['title'].toString(),
            description:
                data[i]['description'] == null || data[i]['description'] == ''
                    ? null
                    : data[i]['description'].toString(),
            isActive: data[i]['is_active'] == null || data[i]['is_active'] == ''
                ? null
                : int.parse(data[i]['is_active'].toString()),
            time: data[i]['time'] == null || data[i]['time'] == ''
                ? null
                : data[i]['time'].toString(),
            createdAt:
                data[i]['created_at'] == null || data[i]['created_at'] == ''
                    ? null
                    : DateTime.parse(data[i]['created_at'].toString()),
            updatedAt:
                data[i]['updated_at'] == null || data[i]['updated_at'] == ''
                    ? null
                    : DateTime.parse(data[i]['updated_at'].toString()),
          );
          reminders.add(businessModel);
        }
      }

      return Result.success(reminders);
    } catch (_) {
      return const Result.failed(errorSystemMessage);
    }
  }

  Future<Result<Response>> insert(Map<String, dynamic> row) async {
    try {
      Database db = await dbInstance.database;
      int id = await db.insert(dbInstance.reminderTable, row);
      storeWorkManager(id);
      return Result.success(
          Response(success: true, message: 'Reminder successfully created'));
    } catch (_) {
      return const Result.failed(errorSystemMessage);
    }
  }

  Future<Result<Response>> update(Map<String, dynamic> row) async {
    try {
      Database db = await dbInstance.database;
      int id = row[dbInstance.reminderId];
      await db.update(dbInstance.reminderTable, row,
          where: '${dbInstance.reminderId} = ?', whereArgs: [id]);
      updateWorkManager(id);
      return Result.success(
          Response(success: true, message: 'Reminder successfully updated'));
    } catch (_) {
      return const Result.failed(errorSystemMessage);
    }
  }

  Future<Result<Reminder?>> find(int id) async {
    Database db = await dbInstance.database;
    final data = await db.rawQuery(
        'SELECT * FROM ${dbInstance.reminderTable} WHERE ${dbInstance.reminderTable}.${dbInstance.reminderId}=$id LIMIT 1',
        []);
    if (data.isNotEmpty) {
      return Result.success(Reminder.fromJson(data[0]));
    }
    return const Result.success(null);
  }

  Future<Result<Response>> delete(int id) async {
    try {
      Database db = await dbInstance.database;
      await db.delete(dbInstance.reminderTable,
          where: '${dbInstance.reminderId} = ?', whereArgs: [id]);
      deleteWorkManager(id);
      return Result.success(
          Response(success: true, message: 'Reminder successfully deleted'));
    } catch (_) {
      return const Result.failed(errorSystemMessage);
    }
  }

  Future<Result<Response>> deleteAll() async {
    try {
      Database db = await dbInstance.database;
      await db.delete(dbInstance.reminderTable);
      deleteAllWorkManager();
      return Result.success(Response(
          success: true, message: 'All reminders successfully deleted'));
    } catch (_) {
      return const Result.failed(errorSystemMessage);
    }
  }

  Future<void> storeWorkManager(int id) async {
    Result<Reminder?> result = await find(id);
    if (result.isSuccess) {
      DateTime now = DateTime.now();
      DateTime parsedTime =
          DateFormat('HH:mm').parse(result.resultValue!.time!);
      DateTime time = DateTime(
          now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

      if (time.isBefore(now)) {
        time = time.add(const Duration(days: 1));
      }

      Workmanager().registerPeriodicTask(
          id.toString(), result.resultValue!.id.toString(),
          initialDelay: time.difference(now),
          frequency: const Duration(days: 1),
          inputData: result.resultValue?.toJson());
    }
  }

  Future<void> updateWorkManager(int id) async {
    Workmanager().cancelByUniqueName(id.toString());

    Result<Reminder?> result = await find(id);
    if (result.isSuccess) {
      DateTime now = DateTime.now();
      DateTime parsedTime =
          DateFormat('HH:mm').parse(result.resultValue!.time!);
      DateTime time = DateTime(
          now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);

      if (time.isBefore(now)) {
        time = time.add(const Duration(days: 1));
      }

      Workmanager().registerPeriodicTask(
          id.toString(), result.resultValue!.id.toString(),
          initialDelay: time.difference(now),
          frequency: const Duration(days: 1),
          inputData: result.resultValue?.toJson());
    }
  }

  deleteWorkManager(int id) {
    Workmanager().cancelByUniqueName(id.toString());
  }

  deleteAllWorkManager() {
    Workmanager().cancelAll();
  }
}
