import 'package:batida_ponto/model/ponto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{
  static const _dbName = 'ponto_eletronico.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();

  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    String dataBasePath = await getDatabasesPath();
    String dbPath = '${dataBasePath}/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db,int version) async{
    await db.execute(
        '''
    CREATE TABLE ${Ponto.NAME_TABLE}(
      ${Ponto.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Ponto.CAMPO_LATITUDE} TEXT NOT NULL,
      ${Ponto.CAMPO_LONGITUDE} TEXT NOT NULL,
      ${Ponto.CAMPO_HORA_PONTO} TEXT,
      ${Ponto.CAMPO_VAR} TEXT NOT NULL
      
    );
    '''
    );
  }

  Future<void> close() async{
    if (_database != null){
      await _database!.close();
    }
  }

}