import 'package:batida_ponto/database/database_provider.dart';
import 'package:batida_ponto/model/ponto.dart';

class PontoDao{
  final dbProvider = DatabaseProvider.instance;
  var Desc = '${Ponto.CAMPO_ID} DESC';

  Future<bool> salvar(Ponto ponto) async{
    final db = await dbProvider.database;
    final valores = ponto.toMap();
    if(ponto.id == 0){
      ponto.id = await db.insert(Ponto.NAME_TABLE, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(
          Ponto.NAME_TABLE,
          valores,
          where: '${Ponto.CAMPO_ID} = ?',
          whereArgs: [ponto.id]);
      return registrosAtualizados > 0;
    }
  }


  Future<List<Ponto>> listar() async{
    final db = await dbProvider.database;
    final resultado = await db.query(Ponto.NAME_TABLE,
        columns: [
          Ponto.CAMPO_ID,
          Ponto.CAMPO_HORA_PONTO,
          Ponto.CAMPO_LATITUDE,
          Ponto.CAMPO_LONGITUDE,
          Ponto.CAMPO_VAR,
        ],
          orderBy: Desc
    );
    return resultado.map((m) => Ponto.fromMap(m)).toList();
  }

}