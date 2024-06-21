import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInstance {
  final String _databaseName = "game_consign.db";
  final int _databaseVersion = 1;

  // Reminder Table
  final String reminderTable = 'reminders';
  final String reminderId = 'id';
  final String reminderTitle = 'title';
  final String reminderDescription = 'description';
  final String reminderTime = 'time';
  final String reminderIsActive = 'is_active';
  final String reminderCreatedAt = 'created_at';
  final String reminderUpdatedAt = 'updated_at';

  // only have a single app-wide reference to the database
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $reminderTable (
            $reminderId INTEGER PRIMARY KEY AUTOINCREMENT,
            $reminderTitle TEXT NULL,
            $reminderDescription TEXT NULL,
            $reminderTime TEXT NULL,
            $reminderIsActive INTEGER NULL,
            $reminderCreatedAt TEXT NULL,
            $reminderUpdatedAt TEXT NULL
          )
          ''');
  }
}
