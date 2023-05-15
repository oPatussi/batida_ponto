import 'package:intl/intl.dart';

class Ponto{

  static const CAMPO_ID = 'id';
  static const CAMPO_HORA_PONTO = 'horaPonto';
  static const CAMPO_LATITUDE = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';
  static const NAME_TABLE = 'gerenciador';
  static const CAMPO_VAR = 'variavel';

  int? id;
  String? horaPonto;
  String? longitude;
  String? latitude;
  String? variavel;

  Ponto({
    this.id,
    this.horaPonto,
    this.longitude,
    this.latitude,
    this.variavel});


  Map<String, dynamic> toMap() =><String, dynamic>{
    CAMPO_ID: id == 0? null : id,
    CAMPO_HORA_PONTO: horaPonto == null ? null : horaPonto,
    CAMPO_LONGITUDE: longitude,
    CAMPO_LATITUDE: latitude,
    CAMPO_VAR: variavel,
  };

  factory Ponto.fromMap(Map<String, dynamic>map) =>Ponto(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    horaPonto: map[CAMPO_HORA_PONTO] is String ? map[Ponto.CAMPO_HORA_PONTO] : null,
    latitude: map[CAMPO_LATITUDE] is String ? map[CAMPO_LATITUDE] : '',
    longitude: map[CAMPO_LONGITUDE] is String ? map[CAMPO_LONGITUDE] : '',
    variavel: map[CAMPO_VAR] is String ? map[CAMPO_VAR] : '',
  );
}