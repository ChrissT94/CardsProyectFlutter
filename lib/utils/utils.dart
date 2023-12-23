import 'package:flutter/material.dart';

/// Creamos la función de alerta
AlertDialog showAlertDialogC(
    BuildContext context, String titulo, String contenido) {
  return AlertDialog(
    title: Text(titulo),
    content: Text(contenido),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () {
          // funcion();
          Navigator.pop(context, true);
        },
        child: const Text('Si'),
      )
    ],
  );

  // Mostrar la alerta
  //showDialog(context: context, builder: (context) => alertDialog);
}
