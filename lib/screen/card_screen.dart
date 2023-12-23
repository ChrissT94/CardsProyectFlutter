import 'package:cards_app/bloc/person_bloc.dart';
import 'package:cards_app/models/person.dart';
import 'package:cards_app/screen/counter_screen.dart';
import 'package:cards_app/screen/custom_card.dart';
import 'package:cards_app/screen/detail_card.dart';
import 'package:cards_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    int idexSelectd = 0;
    final personBloc = PersonBloc();
    List<Widget> widgetBody = [
      StreamBuilder<List<Person>>(
        stream: personBloc.personStream,
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final poeple = snapshot.data;

          if (poeple == null || poeple.isEmpty) {
            return const Center(
              child: Text('No existen datos'),
            );
          }

          print('=====> INDEX: ${poeple.length}');

          return ListView.builder(
            itemCount: poeple.length,
            itemBuilder: (context, index) =>
                CustomCard(poeple[index], const Text('Profile')),
          );
        },
      ),
      CouterScreen(),
      _showGoogleMaps()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('People List'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return showAlertDialogC(context, 'Eliminar Tarjetas',
                          'Esta seguro de eliminar todas las tarjetas?');
                    }).then((value) {
                  if (value) {
                    //DBPersonProvider.db.deleteAll();
                    personBloc.deleteAllPerson();
                  }
                  ;
                });
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      /* body: FutureBuilder(
        /// Primero resuelve este asincronismo y regresa en el snapshot
        future: DBPersonProvider.db.getAll(),

        /// snapshot como lee desde la BDD*/
      body: widgetBody.elementAt(idexSelectd),
      /*StreamBuilder<List<Person>>(
        stream: personBloc.personStream,
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final poeple = snapshot.data;

          if (poeple == null || poeple.isEmpty) {
            return const Center(
              child: Text('No existen datos'),
            );
          }

          print('=====> INDEX: ${poeple.length}');

          return ListView.builder(
            itemCount: poeple.length,
            itemBuilder: (context, index) =>
                CustomCard(poeple[index], const Text('Profile')),
          );
        },
      ),*/
      /* SafeArea(
        child: ListView.builder(
          itemCount: poeple.length,
          itemBuilder: (context, index) =>
              CustomCard(poeple[index], const Text('Profile'), deletePerson),
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailCard(Person(
                    name: '',
                    description: '',
                    age: 0,
                    pathImage: 'assets/profile.png'));
              },
            ),
          ).then((value) {
            Person personAdd = value;
            personBloc.addPerson(personAdd);
            //DBPersonProvider.db.add(personAdd);
            //poeple.add(personAdd);
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.red,
        iconSize: 30.0,
        selectedItemColor: Colors.green,
        // index actual
        currentIndex: idexSelectd,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.countertops),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          )
        ],
        onTap: (int index) {
          setState(() {});
          idexSelectd = index;
          print(index);
        },
      ),
    );
  }

  Widget _showGoogleMaps() {
    late GoogleMapController mapCotroller;
    _myMapCreated(GoogleMapController controller) {
      mapCotroller = controller;
    }

    Marker markerQuito = Marker(
      markerId: const MarkerId('Quito'),
      position: const LatLng(-0.22985, -78.52495),
      infoWindow: const InfoWindow(title: 'Quito'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      draggable: true,
      onDragEnd: (latlng) {
        print(latlng);
      },
      onTap: () => print('Clic a Quito'),
    );

    Marker markerColombia = Marker(
      markerId: const MarkerId('Colombia'),
      position: const LatLng(4.60971, -74.08175),
      infoWindow: const InfoWindow(title: 'Quito'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      draggable: true,
      onDragEnd: (latlng) {
        print(latlng);
      },
      onTap: () => print('Clic a Bogota'),
    );
    return GoogleMap(
      onMapCreated: _myMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-0.22985, -78.52495),
        zoom: 5,
      ),

      mapType: MapType.normal,

      markers: {markerQuito, markerColombia},

      polylines: {
        const Polyline(
            polylineId: PolylineId('Ruta 1'),
            points: [
              LatLng(-0.22985, -78.52495),
              LatLng(4.60971, -74.08175),
            ],
            width: 3,
            color: Colors.red),
      },

      /// Circulo en el punto
      circles: {
        const Circle(
            circleId: CircleId('Geo 1'),
            center: LatLng(-0.22985, -78.52495),
            radius: 800.0,
            strokeColor: Colors.red,
            strokeWidth: 10,
            fillColor: Colors.amber),
      },
    );
  }
}
