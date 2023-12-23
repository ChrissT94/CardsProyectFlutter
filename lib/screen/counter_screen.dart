import 'package:flutter/material.dart';

class CouterScreen extends StatefulWidget {
  @override
  createState() => _ContadorPageState();
}

class _ContadorPageState extends State<CouterScreen> {
  final _estiloTexto = new TextStyle(fontSize: 25);

  int _conteo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cliks Numbers:', style: _estiloTexto),
            Text('$_conteo', style: _estiloTexto),
            _crearBotones()
          ],
        ),
      ),
    );
  }

  Widget _crearBotones() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
            child: Icon(Icons.exposure_zero), onPressed: _reset),
        const SizedBox(width: 15.0),
        FloatingActionButton(child: Icon(Icons.remove), onPressed: _sustraer),
        const SizedBox(width: 15.0),
        FloatingActionButton(child: Icon(Icons.add), onPressed: _agregar),
      ],
    );
  }

  void _agregar() {
    setState(() => _conteo++);
  }

  void _sustraer() {
    setState(() => _conteo--);
  }

  void _reset() {
    setState(() => _conteo = 0);
  }
}
