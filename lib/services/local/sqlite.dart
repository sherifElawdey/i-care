import 'dart:io';
import 'package:icare/helper/paths/links.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DataBaseSql {
  final String idColumn='id';
  final String medicineIdColumn='medicineId';
  final String buyerReferenceColumn='buyerReference';
  final String priceColumn='price';
  final String nameColumn='name';
  final String amountColumn='amount';
  final String isDoneColumn='isDone';

  final String patientIdColumn='patientId';
  final String doctorIdColumn='doctorId';
  final String doctorNameColumn='doctorName';
  final String patientNameColumn='patientName';
  final String payedColumn='payed';
  final String offerColumn='offer';
  final String appointmentDateColumn='appointmentDate';
  final String appointmentStateColumn='appointmentState';

  final String hourColumn='hour';
  final String minuteColumn='minute';

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initializedDatabase();
    return _database;
  }

  Future<Database> initializedDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}care.db';

    var carDB = await openDatabase(path, version: 31, onCreate: createDatabase);
    return carDB;
  }

  Future createDatabase(Database db, int version) async {

    String createOrdersTable='CREATE TABLE $sqlOrderTable ($idColumn TEXT PRIMARY KEY,'
        '$medicineIdColumn TEXT,$buyerReferenceColumn TEXT,$priceColumn TEXT,$nameColumn TEXT,$amountColumn TEXT,$isDoneColumn TEXT)';

    String createAppointmentTable='CREATE TABLE $sqlAppointmentTable ($idColumn TEXT PRIMARY KEY,'
        '$patientIdColumn TEXT,$doctorIdColumn TEXT,$offerColumn TEXT,$doctorNameColumn TEXT,$patientNameColumn TEXT,$payedColumn TEXT,$appointmentDateColumn TEXT,$appointmentStateColumn TEXT)';

    String createReminderTable='CREATE TABLE $sqlRemindersTable ($idColumn INTEGER PRIMARY KEY,'
        '$nameColumn TEXT,$amountColumn TEXT,$hourColumn TEXT,$minuteColumn TEXT)';

    await db.execute(createOrdersTable);
    await db.execute(createAppointmentTable);
    await db.execute(createReminderTable);
  }

  Future<int> addItem(String table,Map<String,dynamic> item)async{
    var dbClint =await database;
    int result= await dbClint!.insert(table,item);
    return result;
  }

  Future<List> getAllItems(String table) async {
    var dbClint =await database;
    List result= await dbClint!.query(table);
    return result.toList();
  }

  Future<int?> getCount(String table)async{
    var dbClint =await database;
    String rwoQuery='SELECT COUNT(*) FROM $table';
    return Sqflite.firstIntValue(await dbClint!.rawQuery(rwoQuery));
  }

  Future<Map<String,dynamic>?> getItem(String table,String id)async{
    var dbClint =await database;
      var result= await dbClint!.query(table,where:idColumn,whereArgs: [id]);
      if(result.isEmpty)return null;
      return result.first;
  }

  Future<int> deleteItem(String table,dynamic id)async{
    var dbClint =await database;
      int result= await dbClint!.delete(table,where: '$idColumn = ?',whereArgs: [id]);
      return result;
  }

  Future<int> deleteAll(String table)async{
    var dbClint =await database;
    int result= await dbClint!.delete(table);
    return result;
  }

  Future<int> updateItems(String table,Map<String,dynamic> item)async{
    var dbClint =await database;
      int result= await dbClint!.update(table,item,where:'$idColumn = ?',whereArgs: [item['id']]);
      return result;
  }

  Future<void> close()async{
    var dbClint = await database;
    await dbClint!.close();
  }
}