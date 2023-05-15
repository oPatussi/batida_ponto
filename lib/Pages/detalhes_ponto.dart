import 'package:batida_ponto/model/ponto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetalhesPontoPage extends StatefulWidget {
  final Ponto ponto;

  const DetalhesPontoPage({Key? key, required this.ponto}) : super(key: key);

  @override
  _DetalhesPontoPageState createState() => _DetalhesPontoPageState();
}

class _DetalhesPontoPageState extends State<DetalhesPontoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Ponto Turistico'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          Row(
            children: [
              Campo(descricao: 'Nome: '),
              Valor(valor: '${widget.ponto.id}')
            ],
          ),
          Row(
            children: [
              Campo(descricao: 'Hora de entrada: '),
              Valor(valor: '${widget.ponto.horaPonto}')
            ],
          ),
          Row(
            children: [
              Campo(descricao: 'Latitude: '),
              Valor(valor: '${widget.ponto.latitude}')
            ],
          ),
          Row(
            children: [
              Campo(descricao: 'Longitude: '),
              Valor(valor: '${widget.ponto.longitude}')
            ],
          )
        ],
      ),
    );
  }
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
      child: Expanded(
          flex: 1,
          child: Text(
            descricao,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}
