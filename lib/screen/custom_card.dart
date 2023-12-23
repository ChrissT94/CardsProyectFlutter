import 'package:cards_app/bloc/person_bloc.dart';
import 'package:cards_app/models/person.dart';
import 'package:cards_app/provider/db_person_provider.dart';
import 'package:cards_app/screen/detail_card.dart';
import 'package:cards_app/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Person person;

  // Puedo enviar un widget
  final Widget myWidget;

  //final Function? delete;

  const CustomCard(this.person, this.myWidget, {super.key});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final personBloc = PersonBloc();
    return Card(
      margin: const EdgeInsets.all(12.9),
      color: Colors.green[200],
      // Shape para dar redondeado a los bordes de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Colocar color a la sombra, va junto con la propiedad elevation
      shadowColor: Colors.blue,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              mainAxisSize:
                  MainAxisSize.min, // centra las columnas a su contenido
              children: [
                widget.myWidget,
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.person.pathImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Picture',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Caja vacía con ul alto
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.person.name,
                ),
              ],
            ),
            // Seperar contenido entre filas
            const SizedBox(
              width: 16.0,
            ),
            //
            Expanded(
              // Con Expanded no se desborda el texto
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.person.description),
                  // Caja vacía con ul alto
                  const SizedBox(
                    height: 9.0,
                  ),
                  Text('Edad: ${widget.person.age}'),
                ],
              ),
            ),
            // Seperar contenido entre filas
            const SizedBox(
              width: 16.0,
            ),

            Container(
              width: 35.0,
              height: 150.0,
              //color: Colors.blue,
              margin: const EdgeInsets.all(8.0),
              child: Stack(children: [
                IconButton(
                    onPressed: () {
                      //widget.function(widget.person);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return showAlertDialogC(context, 'Eliminar Tarjeta',
                                'Esta seguro de eliminar?');
                          }).then((value) {
                        if (value == true) {
                          //widget.delete(widget.person);
                          //  setState(() {});
                          print('Llega ====> $value');
                          personBloc.deletePerson(widget.person.id!);
                          //DBPersonProvider.db.delete(widget.person.id!);
                        }
                      });

                      //widget.delete(widget.person);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCard(widget.person),
                        ),
                      ).then((value) {
                        setState(() {});
                        Person personReturn;
                        personReturn = value;
                        widget.person.name = personReturn.name;
                        widget.person.description = personReturn.description;
                        widget.person.age = personReturn.age;
                        print('========> PRIMARY KEY: ${widget.person.id}');
                        DBPersonProvider.db
                            .update(widget.person.id!, personReturn);
                        print(personReturn.name);
                        print(personReturn.description);
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
