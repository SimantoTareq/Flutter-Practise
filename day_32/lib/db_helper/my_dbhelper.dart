import 'package:day_32/pages/student_details/student_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDbHelper {
  static const String createStTableContact = ''' 
  create table $st_tableContact(
    $st_tableContactColId integer primary key,
    $st_tableContactColName text,
    $st_tableContactColPhone text,
    $st_tableContactColAddress text,
    $st_tableContactColDob text,
    $st_tableContactColGender text,
    $st_tableContactColImage text,

  )
  
  
  ''';

  static Future<Database> initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'st_contact.db');

    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(createStTableContact);
    });
  }

  static Future<int> insertStcontact(StudentModel studentModel) async {
    final st_db = await initDb();
    return st_db.insert(st_tableContact, studentModel.toMap());
  }
}
