import 'dart:async';

import 'package:cards_app/models/person.dart';
import 'package:cards_app/provider/db_person_provider.dart';

class PersonBloc {
  static final PersonBloc _singleton = PersonBloc._internal();

  // Notificar,
  final _personController = StreamController<List<Person>>.broadcast();

  Stream<List<Person>> get personStream => _personController.stream;

  factory PersonBloc() => _singleton;
  PersonBloc._internal() {
    getPerson();
  }

  dispose() {
    _personController.close();
  }

  getPerson() async {
    _personController.sink.add(await DBPersonProvider.db.getAll());
  }

  addPerson(Person person) async {
    await DBPersonProvider.db.add(person);
    getPerson();
  }

  /// Delete All
  deleteAllPerson() async {
    await DBPersonProvider.db.deleteAll();
    getPerson();
  }

  deletePerson(int id) async {
    await DBPersonProvider.db.delete(id);
    getPerson();
  }
}
