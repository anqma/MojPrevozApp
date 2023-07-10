import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moj_prevoz/main.dart';
import 'package:nanoid/nanoid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moj_prevoz/Model/list_prevoz.dart';

class DodadiPrevoz extends StatefulWidget {
  static const routeName = '/dodadi_prevoz';

  const DodadiPrevoz({super.key});

  @override
  State<DodadiPrevoz> createState() => _DodadiPrevozState();
}

class _DodadiPrevozState extends State<DodadiPrevoz> {
  bool mapToggle = false;
  Position? currentLocation;
  GoogleMapController? _mapController;

  final LatLng _center = const LatLng(41.9965, 21.4314);
  List<Marker> myMarker = [];

  final _poagjanjeController = TextEditingController();
  final _pristignuvanjeController = TextEditingController();
  final _datumController = TextEditingController();
  final _slobodniMestaController = TextEditingController();
  final _cenaController = TextEditingController();
  final _voziloController = TextEditingController();
  final _telBrojController = TextEditingController();
  ValueNotifier<bool> _isChecked = ValueNotifier<bool>(false);

  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = const TimeOfDay(hour: 12, minute: 30);
  late DateTime parsedTime;
  late LatLng _latLng = const LatLng(41.9965, 21.4314);

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();

    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future addToDatabase({required ListPrevoz item}) async {
    final docItem =
        FirebaseFirestore.instance.collection('prevozi').doc(item.id);
    final json = item.toJson();
    await docItem.set(json);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      _latLng = tappedPoint;
    });
    _submitData();
  }

  void _submitData() {
    if (_datumController.text.isEmpty ||
        _poagjanjeController.text.isEmpty ||
        _pristignuvanjeController.text.isEmpty ||
        _slobodniMestaController.text.isEmpty ||
        _cenaController.text.isEmpty ||
        _voziloController.text.isEmpty ||
        _telBrojController.text.isEmpty) {
      return;
    }

    final poagjanje = _poagjanjeController.text;
    final pristignuvanje = _pristignuvanjeController.text;
    final vnesenDatum =
        DateFormat('dd/MM/yyyy HH:mm').parse(_datumController.text);
    final slobodniMesta = _slobodniMestaController.text;
    final cena = _cenaController.text;
    final vozilo = _voziloController.text;
    final telBroj = _telBrojController.text;
    final lat = _latLng.latitude;
    final lon = _latLng.longitude;
    GeoPoint geoPoint = GeoPoint(lat, lon);

    final newItem = ListPrevoz(
      id: nanoid(5),
      pocetnaDest: poagjanje,
      krajnaDest: pristignuvanje,
      datumIcas: vnesenDatum,
      slobodniMesta: slobodniMesta,
      cena: cena,
      vozilo: vozilo,
      telBroj: telBroj,
      userId: FirebaseAuth.instance.currentUser!.uid,
      mesto: geoPoint,
    );
    addToDatabase(item: newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 60.0, bottom: 40.0),
                  child: SizedBox(
                    width: 350,
                    child: Text(
                      'Додади превоз',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextField(
                          controller: _poagjanjeController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Место на поаѓање',
                            hintText: 'Внеси место на поаѓање',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      const Text(
                        "Означи место на чекање за поаѓање",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: mapToggle
                              ? GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 12.0,
                                  ),
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  onTap: _handleTap,
                                  markers: Set.from(myMarker),
                                )
                              : const Center(child: Text('Се вчитува...'))),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _pristignuvanjeController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Место на пристигнување',
                            hintText: 'Внеси место на пристигнување',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _datumController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Датум',
                            hintText: 'Внеси датум на патување',
                          ),
                          readOnly: true,
                          onSubmitted: (_) => _submitData(),
                          onTap: () async {
                            pickedDate = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            ))!;
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            setState(() {
                              _datumController.text = formattedDate;
                            });

                            pickedTime = (await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 12, minute: 0)))!;
                            DateTime now = DateTime.now();
                            parsedTime = DateTime(now.year, now.month, now.day,
                                pickedTime.hour, pickedTime.minute);
                            String formattedTime =
                                DateFormat('HH:mm').format(parsedTime);
                            setState(() {
                              _datumController.text =
                                  "${_datumController.text} $formattedTime";
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _slobodniMestaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Број на слободни места',
                            hintText: 'Внеси број на слободни места',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _cenaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Цена во денари',
                            hintText: 'Внеси цена во денари од патник',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _voziloController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Возило',
                            hintText: 'Внеси возило со кое патуваш',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 40.0, left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _telBrojController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Број за контакт',
                            hintText: 'Внеси телефонски број',
                          ),
                          onSubmitted: (_) => _submitData(),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        //elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () => _submitData(),
                          minWidth: 200.0,
                          height: 50.0,
                          color: myColor,
                          child: const Text(
                            "Додади превоз",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ])));
  }
}
