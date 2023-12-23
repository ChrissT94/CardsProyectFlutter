import 'package:cards_app/models/person.dart';
import 'package:cards_app/utils/utils.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatefulWidget {
  final Person _person;
  const DetailCard(this._person, {super.key});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  var setColor = Colors.green;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingControllerDesc =
      TextEditingController();
  final TextEditingController _textEditingControllerAge =
      TextEditingController();
  String _titulo = '';
  String _contenido = '';

  DateTime date1 = DateTime.now();
  TimeOfDay time1 = TimeOfDay.now();

  selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: date1,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        confirmText: 'Seleccionar',
        cancelText: 'Cancelar',
        selectableDayPredicate: (value) {
          return value.weekday == 5 || value.weekday == 6 ? false : true;
        });
    if (picked != null && picked != date1) {
      setState(() {
        date1 = picked;
      });
    }
  }

  selectHour(BuildContext context) async {
    var timed = await showTimePicker(
      context: context,
      initialTime: time1,
    );

    if (timed != null && timed != time1) {
      setState(() {
        time1 = timed;
      });
    }
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      backgroundColor: Colors.greenAccent,
      elevation: 10.0,
      duration: const Duration(seconds: 5),
      content: const Row(
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 25.0,
          ),
          Text('Acción realizada')
        ],
      ),
      action: SnackBarAction(
        label: ':)',
        onPressed: () {},
        textColor: Colors.white,
      ),
    );

    // Mostrar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.text = widget._person.name;
    _textEditingControllerDesc.text = widget._person.description;
    _textEditingControllerAge.text = widget._person.age.toString();
    if (_textEditingController.text.isEmpty) {
      _titulo = 'Crear tarjeta';
      _contenido = 'Esta seguro de crear?';
      print('Aqui 1--> $_textEditingController.text');
    } else {
      print('Aqui 2--> $_textEditingController.text');
      _titulo = 'Actualizar tarjeta';
      _contenido = 'Esta seguro de actualizar?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Detail'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget._person.pathImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(widget._person.name),
                Text(widget._person.description),
                SizedBox(
                  width: 220.0,
                  child: TextField(
                    cursorColor: setColor,
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                    ),
                    controller: _textEditingController,
                  ),
                ),
                SizedBox(
                  width: 220.0,
                  child: TextField(
                    cursorColor: setColor,
                    decoration: const InputDecoration(
                      hintText: 'Profesión',
                    ),
                    controller: _textEditingControllerDesc,
                  ),
                ),
                SizedBox(
                  width: 220.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: setColor,
                    decoration: const InputDecoration(
                      hintText: 'Edad',
                    ),
                    controller: _textEditingControllerAge,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Fecha de nacimiento: '),
                    Text('${date1.year}-${date1.month}-${date1.day}'),
                    IconButton(
                        onPressed: () {
                          selectDate(context);
                        },
                        icon: const Icon(Icons.date_range))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Hora de ingreso: '),
                    Text('${time1.hour}:${time1.minute}'),
                    IconButton(
                        onPressed: () {
                          selectHour(context);
                        },
                        icon: const Icon(Icons.date_range))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(
                      width: 25.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return showAlertDialogC(
                                  context, _titulo, _contenido);
                            }).then((value) {
                          if (value) {
                            setState(() {
                              widget._person.name = _textEditingController.text;
                              widget._person.description =
                                  _textEditingControllerDesc.text;
                              widget._person.age =
                                  int.parse(_textEditingControllerAge.text);
                              Navigator.pop(context, widget._person);
                              _showSnackBar();
                            });
                          }
                        });
                      },
                      child: const Text('Guardar'),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
