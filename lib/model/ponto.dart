import 'package:intl/intl.dart';

class Ponto{

  static const CAMPO_ID = 'id';
  static const CAMPO_HORA_ENTRADA = 'horaEntrada';
  static const CAMPO_HORA_SAIDA = 'horaSaida';
  static const CAMPO_LATITUDE = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';
  static const NAME_TABLE = 'gerenciador';

  int id;
  String nome;
  String descricao;
  DateTime? dataCadastro;
  String diferenciais;
  double longitude;
  double latitude;

  Ponto({
    required this.id,
    required this.nome,
    required this.descricao,
    this.dataCadastro,
    required this.diferenciais,
    required this.longitude,
    required this.latitude});

  String get dataFormatada{
    if(dataCadastro == null){
      return'';
    }else{
      return DateFormat('dd/MM/yyyy').format(dataCadastro!);
    }
  }

  Map<String, dynamic> toMap() =><String, dynamic>{
    CAMPO_ID: id == 0? null : id,
    CAMPO_NOME: nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DIFERENCIAIS: diferenciais,
    CAMPO_DATA_CADASTRO: dataCadastro == null? null: DateFormat('yyyy-MM-dd').format(dataCadastro!),
    CAMPO_LONGITUDE: longitude,
    CAMPO_LATITUDE: latitude,
  };

  factory Ponto.fromMap(Map<String, dynamic>map) =>Ponto(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    diferenciais: map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : '',
    dataCadastro: map[CAMPO_DATA_CADASTRO] == null ? null : DateFormat('yyyy-MM-dd').parse(map[CAMPO_DATA_CADASTRO]),
    latitude: map[CAMPO_LATITUDE] is double ? map[CAMPO_LATITUDE] : '',
    longitude: map[CAMPO_LONGITUDE] is double ? map[CAMPO_LONGITUDE] : '',
  );
}