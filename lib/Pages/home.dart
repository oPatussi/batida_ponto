import 'dart:async';

import 'package:batida_ponto/Pages/detalhes_ponto.dart';
import 'package:batida_ponto/dao/ponto_dao.dart';
import 'package:batida_ponto/model/ponto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _localizacaoAtual;
  String _batida = 'Entrada';
  final _dateFormat = DateFormat('dd.MMMM.yyyy hh:mm aaa');

  static const ACAO_ABRIR_MAPA = 'abrirMapa';
  static const ACAO_VISUALIZAR = 'visualizar';

  final _pontos = <Ponto>[];
  final _dao = PontoDao();


  @override
  Widget build(BuildContext context) {
    _update();
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  void _update() async{
    final ponto = await _dao.listar();
    setState(() {
      _pontos.clear();
      if(ponto.isNotEmpty){
        _pontos.addAll(ponto);
      }
    });
  }

  AppBar _criarAppBar() {
    return AppBar(title: const Text('Bater Ponto'),
        actions: [
          IconButton(
            onPressed: _obterLocalizacaoAtual,
            icon:const Icon(Icons.add_alarm_rounded)),
          IconButton(
              onPressed: _update,
               icon: const Icon(Icons.refresh))
    ],
    );
  }


  // Widget _criarBody(){
  //   return ListView.separated(
  //     itemCount: _pontos.length,
  //     itemBuilder: (BuildContext context, int index){
  //       final ponto = _pontos[index];
  //       return PopupMenuButton<String>(
  //           child: ListTile(
  //             title: Text(
  //               '${ponto.id}',
  //             ),
  //             subtitle: Text('Hora batida: ${ponto.horaPonto}  |  ${_batida}',
  //             ),
  //           ),
  //           itemBuilder: (BuildContext context) => _criarItensMenu(),
  //           onSelected: (String valorSelecinado){
  //             if(valorSelecinado == ACAO_ABRIR_MAPA){
  //               _abrirCoordenadasNoMapaExterno(ponto);
  //             }else if(valorSelecinado == ACAO_VISUALIZAR){
  //               _abrirPaginaDetalhesPonto(ponto);
  //             }
  //           }
  //       );
  //     },
  //     separatorBuilder: (BuildContext context, int index) => Divider(),
  //   );
  // }

  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _pontos.length,
              itemBuilder: (BuildContext context, int index){
                final ponto = _pontos[index];
                return PopupMenuButton<String>(
                  child: ListTile(
                    leading: Text('${ponto.id}'),
                    title: Text('${ponto.horaPonto} | ${ponto.variavel}'),
                    subtitle: Text('Lat: ${ponto.latitude} '
                        'Long: ${ponto.longitude}'),
                  ),
                  itemBuilder: (_) => _criarItensMenu(),
                  onSelected: (String valorSelecionado) {
                    if (valorSelecionado == ACAO_VISUALIZAR) {
                      _abrirPaginaDetalhesPonto(ponto);
                    }else if (valorSelecionado == ACAO_ABRIR_MAPA) {
                      _abrirCoordenadasNoMapaExterno(ponto);
                    }
                  },
                );
              },
              separatorBuilder: (_, __) => Divider(),
            )
        )
      ],
    ),
  );

  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_ABRIR_MAPA,
        child: Row(
          children: [
            Icon(Icons.map, color: Colors.lightBlue),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Abrir no mapa externo'),
            )
          ],
        ),
      ),PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.launch, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar ponto'),
            )
          ],
        ),
      ),
    ];
  }



  // void _baterPonto() async{
  //   _obterLocalizacaoAtual();
  //   DateTime horaBatida = DateTime.now();
  //
  //  DUVIDA !!!!!
  // }

  void flipPonto(){
    if (_batida == 'Entrada'){
      _batida = 'Saida';
    }else{
      _batida = 'Entrada';
    }
  }

  void _abrirPaginaDetalhesPonto(Ponto ponto) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => DetalhesPontoPage(
              ponto: ponto,
            )
        ));
  }

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {
    });
    Ponto ponto = Ponto(id:0);
    ponto.horaPonto = _dateFormat.format(DateTime.now());
    ponto.longitude = _localizacaoAtual?.longitude == null ? '${_localizacaoAtual?.longitude}': '${_localizacaoAtual?.longitude}';
    ponto.latitude = _localizacaoAtual?.latitude == null ? '${_localizacaoAtual?.latitude}': '${_localizacaoAtual?.latitude}';
    ponto.variavel = _batida;
    _dao.salvar(ponto);

    _update();
    flipPonto();
  }

  void _abrirCoordenadasNoMapaExterno(ponto){
    if(_localizacaoAtual == null){
      return;
    }
    var lat = double.parse(ponto.latitude);
    var lon = double.parse(ponto.longitude);
    MapsLauncher.launchCoordinates(lat,lon);
  }


  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if(!servicoHabilitado){
      await _mostrarMensagemDialog('Para utilizar esse recurso, você deverá habilitar o serviço de localização '
          'no dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recusro por falta de permissão');
        return false;
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarMensagemDialog(
          'Para utilizar esse recurso, você deverá acessar as configurações '
              'do appe permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;

  }
  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarMensagemDialog(String mensagem) async{
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


}
